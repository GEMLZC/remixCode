// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract TestContract {
    string public message;
    uint public number;

    event Log(address caller, uint256 amount, string message);

    function foo(string memory _msg, uint256 _num) external payable {
        message = _msg;
        number = _num;
    }

    fallback() external payable { 
       emit  Log(msg.sender,msg.value,"Fallback was called");
    }

    receive() external payable { 
         emit  Log(msg.sender,msg.value,"");
    }
}


contract Caller {
    event Log(address caller, uint256 amount, string message);
    bytes public data;
    function callFoo(address _testContract, string memory _msg, uint256 _num) external payable {
        (bool success, bytes memory _data) = 
        _testContract.call{value:_num}(abi.encodeWithSignature("foo(string,uint256)",_msg,_num));
        require(success, "call failed");
        data = _data;
    }

    function callNonExistentFunction(address _testContract) external{
        (bool success, bytes memory _data) = 
        _testContract.call{value:111}(abi.encodeWithSignature("foo1(string,uint256)"));
         require(success, "call failed");
        data = _data;
    }

     receive() external payable { 
         emit  Log(msg.sender,msg.value,"");
    }
}