// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract Chat {
    event LogMessage(address indexed  _from,address indexed _to,string message);

    function sendMessage(address _to,string memory message) external {
        emit LogMessage(msg.sender,_to,message);
    }
}