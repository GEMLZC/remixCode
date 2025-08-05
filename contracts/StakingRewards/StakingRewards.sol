// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

/**
    质押代币（角色：奖励发放者，质押用户）
    奖励发放者发放奖励，质押用户质押代币获取奖励
*/
contract StakingRewards{
     event Log(uint256 r);
    //质押代币
    IERC20 public immutable stakingToken;
    //领取代币
    IERC20 public immutable rewardsToken;
    //管理员
    address public owner;
    //结束时间
    uint256 public endTime;
    //上次更新奖励数据的时间戳
    uint256 public updatedAt;
    //奖励发放持续时间
    uint256 public duration;
    //奖励速率 每秒
    uint256 public rewardRate;
    //奖励系数
    uint256 public rewardCoefficient;
    //每个代币的累计奖励
    uint256 public rewardPerTokenStored;
    //每个用户的每个代币的累计奖励
    mapping(address => uint) public rewardPerTokenStoredOf;
    //每个用户质押的代币
    mapping(address => uint) public balanceOf;
    //每个用户可以领取的奖励
    mapping(address => uint) public rewardOf;
    //质押的总代币
    uint256 public totalBalance;


    constructor(address _stakingToken,address _rewardsToken) {
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        owner = msg.sender;
    }

    //管理员校验
    modifier onlyOwner(){
        require(msg.sender == owner,"not owner");
        _;
    }

    //计算用户奖励
    modifier updateReward(){
        //每个代币的累计奖励
        rewardPerTokenStored = updateRewardPerTokenStored();
        updatedAt =  _minTime();
       
        if(rewardPerTokenStored > 0){
            rewardOf[msg.sender] = earned();
            rewardPerTokenStoredOf[msg.sender] = rewardPerTokenStored;
        }
        _;
        
    }

    function updateReward2() public updateReward{

    }

    //计算用户可获取的收益
    function earned() private  returns(uint){
        return ((updateRewardPerTokenStored() - rewardPerTokenStoredOf[msg.sender]) 
                * balanceOf[msg.sender]/ 1e18) +rewardOf[msg.sender];
    }
    //计算用户可获取的收益 方法2  每个质押代币产生的收益 * 持续时间 = 收益
     function earned2() private returns(uint){
        rewardCoefficient = (rewardRate / totalBalance) * 1e18;
        return (rewardCoefficient * balanceOf[msg.sender] / 1e18) +rewardOf[msg.sender] ;
    }

    function getUseEarned() public  returns(uint){
        
        return earned();
    }

    function getUseEarned2() public view returns(uint){
        
        return ((rewardRate / totalBalance) * 1e18) *  balanceOf[msg.sender] / 1e18 + rewardOf[msg.sender];
    }

    //计算每个代币的累计奖励
    function updateRewardPerTokenStored() private returns(uint){
        uint r = totalBalance == 0 ? rewardPerTokenStored :
        rewardPerTokenStored + (rewardRate * (_minTime() - updatedAt) * 1e18 /totalBalance);
        return r;
    }

    function _minTime() public   returns(uint min){
        min = block.timestamp > endTime ? endTime : block.timestamp;
        emit Log(min);
    }

    function setDuration(uint256 _duration) external onlyOwner{
        require(endTime < block.timestamp, "reward duration not finished");
        duration = _duration;
        
    }


    //管理员注入新的奖励代币并计算/更新奖励分发速率
    function notifyRewardAmount(uint256 _amont) external onlyOwner updateReward{
        require(_amont > 0,"set _amont error");
         // 添加代币转入逻辑
        rewardsToken.transferFrom(msg.sender, address(this), _amont);
        //进入下一周期的质押奖励
        if (block.timestamp > endTime){
            rewardRate = _amont / duration;
        }else{
            //（剩余的奖励+本次质押的代币）/ 持续时间 = 奖励速率
            rewardRate = ((rewardRate * (endTime - block.timestamp)) + _amont) / duration;
            require(rewardRate > 0,"reward rate = 0");
            require(rewardRate * duration <= rewardsToken.balanceOf(msg.sender),"reward amount > balance");
           
        }
         endTime = block.timestamp + duration;
        updatedAt = block.timestamp;
        
    }


    //质押代币
    function stake(uint256 _amont) external payable updateReward{
         require(_amont > 0,"stake _amont error");
         require(stakingToken.balanceOf(msg.sender) >= _amont,"money not enough");
         totalBalance += _amont;
         balanceOf[msg.sender] += _amont;
         stakingToken.transferFrom(msg.sender, address(this), _amont);
    }
    //提取代币
    function withdraw(uint256 _amont) external updateReward{
         require(_amont > 0,"stake _amont error");
         totalBalance -= _amont;
         balanceOf[msg.sender] -= _amont;
         stakingToken.transfer(msg.sender, _amont);
    }

    //提取收益
    function getReward() external updateReward{
        uint256 rewards = rewardOf[msg.sender];
        if (rewards > 0){
            rewardOf[msg.sender] = 0;
             // 检查合约当前是否有足够的余额
            uint256 balance = rewardsToken.balanceOf(address(this));
            require(balance >= reward, "Insufficient reward token balance");
            rewardsToken.transfer(msg.sender, rewards);
        }

    }
    
}