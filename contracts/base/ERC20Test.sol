// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

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


contract ERC20Impl2 is IERC20 {
        //代币总供给
        uint256 public override  totalSupply;
        //account所持有的代币数.
        mapping(address => uint256) public override balanceOf;
        //owner账⼾授权给spender账⼾的额度
        mapping(address => mapping(address => uint256)) public override  allowance;

        
        modifier checkAmountEnough(uint256 amount){
            require(balanceOf[msg.sender] >= amount, "amount is not enough");
            _;
        }


        /**
        * @dev 转账 amount 单位代币，从调⽤者账⼾到另⼀账⼾ to.
        *
        * 如果成功，返回 true.
        *
        * 释放 {Transfer} 事件.
        */
        function transfer(address recipient, uint256 amount) checkAmountEnough(amount) override external returns(bool){
                        balanceOf[msg.sender] -= amount;
                        balanceOf[recipient] += amount;
                        emit Transfer(msg.sender,  recipient, amount);
                        return true;
        }

        
        /**
        * @dev 调⽤者账⼾给spender账⼾授权 amount数量代币。
        *
        * 如果成功，返回 true.
        *
        * 释放 {Approval} 事件.
        */
        function approve(address spender, uint256 amount) checkAmountEnough(amount) override external returns (bool){
            allowance[msg.sender][spender] = amount;
            emit  Approval(msg.sender,  spender, amount);
            return true;
        }


        /**
        * @dev 通过授权机制，从from账⼾向to账⼾转账amount数量代币。转账的部分会从调⽤者的
            allowance中扣除。
        *
        * 如果成功，返回 true.
        *
        * 释放 {Transfer} 事件.
        */
        function transferFrom(address sender, address recipient, uint256 amount) override external returns (bool){
            require(allowance[sender][msg.sender] >= amount, "amount is not enough");
            require(balanceOf[sender] >= amount, "amount is not enough");
            allowance[sender][msg.sender] -= amount;
            balanceOf[sender] -=amount;
            balanceOf[recipient] +=amount;
            emit Transfer(sender,  recipient, amount);
            return true;
        }


        function mint(uint amount) external {
            balanceOf[msg.sender] += amount;
            totalSupply += amount;
            emit Transfer(address(0), msg.sender, amount);
        }


        function burn(uint amount) external {
            balanceOf[msg.sender] -= amount;
            totalSupply -= amount;
            emit Transfer(msg.sender, address(0), amount);
        }
}























contract ERC20Impl is IERC20 {
        // 代币总供应
        uint public override totalSupply;
        //账户余额
        mapping(address => uint256) public override balanceOf;
        //授权账户的额度
        mapping(address => mapping(address => uint256)) public override allowance;

        string public name = "TestToken";
        string public symbol = "TEST";
        uint8 public decimals = 18;

        modifier checkBalanceEnough( uint256 amount){
            require(balanceOf[msg.sender] >= amount, "balance is not enough");
            _;

        }


        /**
        * @dev 转账 amount 单位代币，从调⽤者账⼾到另⼀账⼾ to.
        *
        * 如果成功，返回 true.
        *
        * 释放 {Transfer} 事件.
        */
        function transfer(address recipient, uint256 amount) checkBalanceEnough(amount) override external returns(bool){
           
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;
            emit Transfer(msg.sender, recipient, amount);
            return true;
        }


        /**
        * @dev 调⽤者账⼾给spender账⼾授权 amount数量代币。 (allowance[msg.sender][spender] 是从授权者角度调用的，spender是被授权者，msg.sender是授权者)
        *
        * 如果成功，返回 true.
        * spender：被授权者地址
        * 释放 {Approval} 事件.
        */
        function approve(address spender, uint256 amount) checkBalanceEnough(amount) override external returns (bool){
            allowance[msg.sender][spender] = amount;
            emit Approval(msg.sender, spender, amount);
            return true;
        }


        /**
        * @dev 通过授权机制，从from账⼾向to账⼾转账amount数量代币。转账的部分会从调⽤者的
            allowance中扣除。(allowance[from][msg.sender] 是从被授权者角度调用的，from是授权者，msg.sender是被授权者)
        *
        * 如果成功，返回 true.
        *from :授权者地址
        to:t被授权者
        * 释放 {Transfer} 事件.
        */
        function transferFrom(address from, address to, uint256 amount) override external returns (bool){
             require(balanceOf[from] >= amount, "balance is not enough");
             require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
             balanceOf[from] -= amount; 
             balanceOf[to] += amount;
             allowance[from][msg.sender] -= amount;
             emit Transfer(from, to, amount);
             return true;
        }
}