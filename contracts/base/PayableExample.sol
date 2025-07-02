// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract PayableExample {
    address payable public   recipient;

    constructor() {
        recipient = payable(msg.sender);
    }

    function receiveEther() external payable {}

    function queryBalance() public payable returns (uint){
        return msg.value;
    }
}