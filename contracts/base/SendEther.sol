// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract SendEther {
    
    
    function sendByTransfer(address payable _to,uint eth) external payable {
        _to.transfer(eth);
    }


     function sendBySend(address payable _to,uint eth) external payable {
        bool success = _to.send(eth);
        require(success, "Send Fail");
    }


    function sendByCall(address payable _to,uint eth) external payable {
        (bool success,) = _to.call{value:eth}("");
        require(success, "Send Fail");
    }
}


contract test {
    
    event Log(string functionCalled, address sender, uint amount, bytes data);
    receive() external payable { 
        emit Log("88888",msg.sender,msg.value,"");
    }
}