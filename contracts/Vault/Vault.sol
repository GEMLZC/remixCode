// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
/***
    金库合约，用于存储金库

 */
contract Vault{
    //用户的份额余额
    mapping(address => uint256) public balances;

    //金库的总余额
    uint256 public totalBalance;

    
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    //存入代币
    function _mint(address _to,uint256 _shares) private{
        balances[_to] += _shares;
        totalBalance += _shares;
    }

    //提取代币
    function _burn(address _from,uint256 _shares) private{
         balances[_from] -= _shares;
         totalBalance -= _shares;
    }

    /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B  份额计算公式
        */
    function deposit(uint256 amount) external{
        require(amount > 0, "amount must be greater than 0");
        uint256 shares;
        /**此处有漏洞，合约创建时，没有代币，导致totalBalance为0，Solidity没有浮点型
            shares = amount * totalBalance / token.balanceOf(address(this)); 
            当计算结果小于1时，会向下取整，计算结构为0，导致份额计算错误；攻击者利用该漏洞，提前代币时会获得大量的份额
            shares = amount  应该由合约创建人给予第一笔份额（永久锁死这个份额）
            */
        if(totalBalance == 0){
            shares = amount;  
        }else{
            shares = amount * totalBalance / token.balanceOf(address(this));
           
        }

         _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
    }

     /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T 计算退的代币数量
        */
     function withdraw(uint256 _shares) external {
        uint256 amount = _shares * token.balanceOf(address(this)) / totalBalance;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
     }
       


    
}


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