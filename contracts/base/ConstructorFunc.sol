// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract ConstructorFunc {
    uint private num;
    constructor(uint x) {
        num = x;
    }


    function getX() public view returns (uint){
        return num;
    }
}