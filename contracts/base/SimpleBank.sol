// SPDX-License-Identifier: GPL-3.0
/**
创建⼀个公开的映射 balances ，键类型为 address ，值类型为 uint 。
实现⼀个函数 deposit() ，允许⽤⼾为⾃⼰的账⼾存款。
实现⼀个函数 withdraw(uint amount) ，允许⽤⼾从⾃⼰的账⼾中提取⾦额。
实现⼀个函数 checkBalance() ，返回调⽤者的当前余额。
*/
pragma solidity 0.8.4;
contract SimpleBank {
    mapping(address => uint) public balance; 


    function deposit() public payable  {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require (balance[msg.sender] >= amount, "Insufficient balance");
        payable(msg.sender).transfer(amount);
        balance[msg.sender] -= amount;
    }

    function checkBalance() public view returns (uint){
        return balance[msg.sender];
    }
}