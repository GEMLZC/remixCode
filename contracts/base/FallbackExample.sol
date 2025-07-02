// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract FallbackExample {
    event Log(string functionCalled, address sender, uint amount, bytes data);

    fallback() external payable {
        emit Log("5555555",msg.sender,msg.value,msg.data);
    }

    /*receive() external payable { 
        emit Log("666666",msg.sender,msg.value,"");
    }*/
}