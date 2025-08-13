// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FarmingC2N is Ownable{
    using SafeERC20 for IERC20;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);

    //用户
    struct UserInfo{
        //用户质押的代币数量
        uint256 amount;
        //用户已领取的奖励
        uint256 rewardDebt;
    }

    //代币池信息
    struct PoolInfo{
        //代币地址
        IERC20 tokenAddr;
        //总质押量
        uint256 totalDeposits;
        //代币在此代币池中的累计奖励(比例)
        uint256 accERC20PerShare;
        //上次更新奖励的时间
        uint256 lastRewardTimestamp;
        //代币对应的比例  例如有三个池子abc对应的分数为a:b:c=10:20:10 那么在进行质押计算时,a=25%,b=50%,c=25%
        uint256 allocPoint;
    }


    //开始时间
    uint256 public  startTime;
    //结束时间
    uint256 public  endTime;
    //代币奖励速率
    uint256 public  rewardPerSecond;
    //代币池数组存储
    PoolInfo[] public poolInfoArr;
    //某个代币池下的某个用户的信息  [PoolId（数组索引）,[用户地址，用户信息]]
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    // 总分配分数
    uint256 public  totalAllocPoint;
    //Farm代币地址
    IERC20 public immutable farmAddr;
    // 奖励代币已经发出去的数量
    uint256 public paidOut;

    // 总奖励数量（最多可奖励的数量）
    uint256 public totalRewards;

    constructor(uint256 _startTime,IERC20 _farmAddr,uint256 _rewardPerSecond)
     Ownable(msg.sender){
        farmAddr = _farmAddr;
        startTime = _startTime;
        endTime = _startTime;
        rewardPerSecond = _rewardPerSecond;
    }

    //添加新的代币池
    function add(address _tokenAddr,uint256 allocPoint) external onlyOwner{
        require(_tokenAddr != address(0), "_tokenAddr error");
        uint256 _lastRewardTimestamp = block.timestamp > endTime ? endTime : block.timestamp;
        poolInfoArr.push(PoolInfo(IERC20(_tokenAddr),0,0,_lastRewardTimestamp,allocPoint));
    }


    //往奖励合约注入代币，延长奖励时间
    function fund(uint256 _amount) public onlyOwner{
         require(_amount > 0, "_amount error");
         require(block.timestamp < endTime, "fund: too late, the farm is closed");
         farmAddr.transferFrom(msg.sender, address(this), _amount);
         endTime += _amount / rewardPerSecond;
         totalRewards += _amount;
    }

    //紧急提取代币，不要任何奖励
    function emergencyWithdraw(uint256 _pid) public {
        UserInfo storage _userInfo = userInfo[_pid][msg.sender];
        PoolInfo storage _poolInfo = poolInfoArr[_pid];
        uint256 _amount = _userInfo.amount;
        _poolInfo.totalDeposits -= _amount;
        _userInfo.amount = 0;
        _userInfo.rewardDebt = 0;
        _poolInfo.tokenAddr.safeTransfer(msg.sender,_amount);
        emit EmergencyWithdraw(msg.sender,_pid,_amount);
    }

    //编写更新单个池子奖励的函数（updatePool）
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfoArr[_pid];
        uint256 lastTimestamp = block.timestamp < endTime ? block.timestamp : endTime;
        uint256 lastRewardTimestamp = pool.lastRewardTimestamp;
        //如果小于上一次奖励的刷新时间，就不再更新奖励
        if (lastTimestamp  <= lastRewardTimestamp){
            return;
        }
        uint256 totalDeposits = pool.totalDeposits;
        if (totalDeposits == 0){
            pool.lastRewardTimestamp = lastTimestamp;
            return;
        }
        
        //时间差计算
        uint256 nrOfSeconds = lastTimestamp - lastRewardTimestamp;
        uint256 allocPoint = pool.allocPoint;
        //当前矿池的奖励
        uint256 erc20Reward =  nrOfSeconds * rewardPerSecond * allocPoint / totalAllocPoint;
        //奖励比例 = 奖励速率 * 总质押量
        pool.accERC20PerShare = pool.accERC20PerShare + erc20Reward *1e36 /totalDeposits;
        pool.lastRewardTimestamp = block.timestamp;
    }


    //查询用户某时间段内代币奖励
    function pending(uint256 _pid, address _user) external view returns (uint256) {
            PoolInfo storage pool = poolInfoArr[_pid];
            UserInfo storage user = userInfo[_pid][_user];
            uint256 accERC20PerShare = pool.accERC20PerShare; 
            if (block.timestamp > pool.lastRewardTimestamp && pool.totalDeposits != 0){
                uint256 lastTimestamp = block.timestamp < endTime ? block.timestamp : endTime;
                uint256 lastRewardTimestamp = pool.lastRewardTimestamp;
               
                //时间差计算
                uint256 nrOfSeconds = lastTimestamp - lastRewardTimestamp;
                uint256 allocPoint = pool.allocPoint;
                //当前矿池的奖励
                uint256 erc20Reward =  nrOfSeconds * rewardPerSecond * allocPoint / totalAllocPoint;
                //奖励比例 = 奖励速率 * 总质押量
                accERC20PerShare = pool.accERC20PerShare + erc20Reward *1e36 /pool.totalDeposits;
            }
            return user.amount*pool.accERC20PerShare / 1e36 ;

    }

    //往代币池质押代币
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfoArr[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        //计算可提取的奖励，并把奖励转给用户
        if (user.amount > 0){
            uint256 reward = user.amount*pool.accERC20PerShare / 1e36 - user.rewardDebt;
            erc20Transfer(msg.sender,reward);
        }
        user.amount += _amount;
        pool.totalDeposits += _amount;
        user.rewardDebt = user.amount*pool.accERC20PerShare / 1e36 ;
        pool.tokenAddr.safeTransferFrom(msg.sender,address(this),_amount);
        emit Deposit(msg.sender, _pid, _amount);

    }


    //提取奖励和代币
     function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfoArr[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        require(user.amount >= _amount, "withdraw: can't withdraw more than deposit");
         //计算可提取的奖励，并把奖励转给用户
        if (user.amount > 0){
            uint256 reward = user.amount*pool.accERC20PerShare / 1e36 - user.rewardDebt;
            erc20Transfer(msg.sender,reward);
        }
         user.amount -= _amount;
         user.rewardDebt = user.amount*pool.accERC20PerShare / 1e36 ;
         pool.totalDeposits -= _amount;
         pool.tokenAddr.safeTransfer(msg.sender,_amount);
        emit Withdraw(msg.sender, _pid, _amount);
     }



    function erc20Transfer(address sender,uint256 reward) internal {
        farmAddr.safeTransfer(sender,reward);
        paidOut += paidOut;
    }

    function poolLength() external view returns (uint256) {
        return poolInfoArr.length;
    }

     //用于 动态调整指定池的奖励分配权重，确保奖励分配比例的灵活性和公平性
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint-poolInfoArr[_pid].allocPoint+_allocPoint;
        poolInfoArr[_pid].allocPoint = _allocPoint;
    }

    function massUpdatePools() internal {
        for (uint i=0; i < poolInfoArr.length; i++){
            updatePool(i);
        }
    }

}