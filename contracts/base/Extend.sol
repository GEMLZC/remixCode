// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
创建⼀个Solidity程序，包含三个合约：ContractA，ContractB和ContractC。
◦
ContractA：定义两个函数 foo() 和 bar() ，返回字符串"A"。
ContractB：继承ContractA，重写 foo() 和 bar() ，使其返回字符串"B"。
ContractC：继承ContractB，只重写 bar() ，使其返回字符串"C"。
*/

contract ContractA {

    function foo() external pure virtual  returns (string memory){
        return "A";
    }

     function bar() external pure virtual  returns (string memory){
        return "A";
    }
}


contract ContractB is ContractA{

    function foo() external pure override   returns (string memory){
        return "B";
    }

     function bar() external pure virtual  override  returns (string memory){
        return "B";
    }
}

contract ContractC is ContractB{


     function bar() external pure override  returns (string memory){
        return "C";
    }
}