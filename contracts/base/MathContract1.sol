// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract MathContract{
    uint public storedValue;

    constructor () {
        storedValue = 100;
    }

    function getStoredValue() external view returns(uint){
        return storedValue;
    }

    function multiply(int a, int b) public pure returns (int){
        return a * b;
    }



}