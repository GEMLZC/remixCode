// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;


contract ImmutableExample {
    address public immutable addr;

    constructor() {
        addr = msg.sender;
    }


    function getOwner() public view returns(address){
        return addr;
    }
}