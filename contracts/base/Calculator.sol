// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract Calculator{
    function add(int a, int b) public pure returns (int){
        return a + b;
    }

        function sub(int a, int b) public pure returns (int){
        return a + b;
    }

    
    function multiply(int a, int b) public pure returns (int){
        return a * b;
    }

    function divide(int a, int b) public pure returns (int){
       require(b != 0, "Cannot divide by zero");
        return a / b;
    }
}