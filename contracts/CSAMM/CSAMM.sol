// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;


interface IERC20 {
        /**
        * @dev 返回代币总供给.
        */
        function totalSupply() external view returns (uint256);

        /**
        * @dev 返回账⼾account所持有的代币数.
        */
        function balanceOf(address account) external view returns (uint256);

        /**
        * @dev 转账 amount 单位代币，从调⽤者账⼾到另⼀账⼾ to.
        *
        * 如果成功，返回 true.
        *
        * 释放 {Transfer} 事件.
        */
        function transfer(address recipient, uint256 amount) external returns(bool);

        /**
        * @dev 返回owner账⼾授权给spender账⼾的额度，默认为0。
        *
        * 当{approve} 或 {transferFrom} 被调⽤时，allowance会改变.
        */
        function allowance(address owner, address spender) external view returns(uint256);

        /**
        * @dev 调⽤者账⼾给spender账⼾授权 amount数量代币。
        *
        * 如果成功，返回 true.
        *
        * 释放 {Approval} 事件.
        */
        function approve(address spender, uint256 amount) external returns (bool);


        /**
        * @dev 通过授权机制，从from账⼾向to账⼾转账amount数量代币。转账的部分会从调⽤者的
            allowance中扣除。
        *
        * 如果成功，返回 true.
        *
        * 释放 {Transfer} 事件.
        */
        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


        event Transfer(address indexed from, address indexed to, uint256 value);
        event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
恒定和⾃动做市商算法，去中心化交易所
*/
contract CSAMM{
    //两个不同的代币
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    //当前合约中的代币资金池
    uint256 public reserve0;
    uint256 public reserve1;

    // 保存交换前的资金池乘积
    uint256 public kLast; 

    //总的流动性
    uint256 public totalBlance;
    //用户的流动性
    mapping(address => uint256) public balanceOf;


    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }


    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalBlance += amount;
    }

    function _burn(address to, uint256 amount) internal {
        balanceOf[to] -= amount;
        totalBlance -= amount;
    }


    function _update(uint256 _reserve0, uint256 _reserve1) internal {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }


    // 计算当前资金池的乘积
    function k() public view returns(uint256){
        return reserve0 * reserve1;
    }

    //添加流动性
    function addLiquidity(uint256 amount0, uint256 amount1) external  {
        //转入代币给到当前合约
        token0.transferFrom(msg.sender,address(this),amount0);
        token1.transferFrom(msg.sender,address(this),amount1);

        //计算增量
        uint256 bal0 = token0.balanceOf(address(this));
        uint256 bal1 = token1.balanceOf(address(this));

        uint256 d0 = bal0 - reserve0;
        uint256 d1 = bal1 - reserve1;

        //计算出流动性
        uint256 share;
        if (totalBlance > 0){
           share = ((d0 + d1) * totalBlance) / (reserve0 + reserve1);
        }else{
            share = d0 + d1;
        }
         
        _mint(msg.sender, share);

        //更新资金池
        _update(bal0,bal1);
    }

    //移除流动性
    function removeLiquidity(uint256 _shares) external  {
        uint256 d0 =  (_shares * reserve0) / totalBlance;
        uint256 d1 =  (_shares * reserve1) / totalBlance;
        //销毁份额
        _burn(msg.sender,_shares);
        //资金池减少对应的代币
        _update(reserve0 - d0, reserve1 - d1);
        if (d0 > 0){
            token0.transfer(msg.sender, d0);
        }

        if (d1 > 0){
            token1.transfer(msg.sender, d1);
        }
    }

    //代币交换
    function swap(address _tokenIn,uint256 _amount) external  {
        require(IERC20(_tokenIn) == token0 || IERC20(_tokenIn) == token1,"fei fa token");

        bool isToken0 = IERC20(_tokenIn) == token0;
        //判断出哪种代币交换成另外一种
        (IERC20 tokenIn,IERC20 tokenOut,uint256 resIn,uint256 resOut) = 
        isToken0 ? (token0,token1,reserve0,reserve1) : (token1,token0,reserve1,reserve0);
        
        tokenIn.transferFrom(msg.sender, address(this), _amount);
        //保险起见重新计算代币增量，理论上是和参数_amount一致的，但是必须按照链上的状态计算获取
        uint256 amountIn = tokenIn.balanceOf(address(this)) - resIn;
        //计算扣减手续费后的兑换代币
        uint256 amountInWithFee = (amountIn * 997) / 1000; // 0.3% fee
        //计算交换后的代币数量
        (uint256 res0, uint256 res1) = isToken0 ? 
        (resIn + amountIn,resOut - amountInWithFee) : (resOut - amountInWithFee,resIn + amountIn);
        _update(res0, res1);
        tokenOut.transfer(msg.sender, amountInWi   thFee);
    }
}