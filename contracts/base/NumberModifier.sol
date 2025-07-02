// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract NumberModifier {
    uint private number;

    modifier nonZero(){
        require(number == 0, "Number is not zero");
        _;
    }

    modifier gtZero(uint _x){
        require(_x > 0, "Number ge zero");
        _;
    }

    modifier addNum(){
        number += 1;
        _;
        number += 1;
    }



    function doubleNumber() external nonZero{
        number += 2;
    }

    function addNumber() external addNum{
        number += 2;
    }

    function addNumber2(uint _x) external gtZero(_x){
        number += 2;
    }
    
    function resetNumber() external {
        number = 0;
    }

    function getNum () public view returns(uint){
        return number;
    }
}