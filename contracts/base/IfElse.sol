// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract IfElse{

    function processNumber(int x) external pure returns (int) {
        if(x < 10){
            return  1;
        }else if (x >= 10 && x <= 20){
            return 2;
        }else {
            return 3;
        }
    }

    //当您尝试返回一个具体的数字时，比如 1、2 或 3 时，Solidity 会将其转换为 uint256 类型，而不是 int。
    // function processNumber2(int _x) external pure returns (int) {
    //    return _x < 10 ? 1 : (_x >= 10 && _x <= 20 ? 2:3);
    // }

    function processNumber2(int _x) external pure returns (uint) {
       return _x < 10 ? 1 : (_x >= 10 && _x <= 20 ? 2:3);
    }

    function tenary(uint _x) external pure returns (uint) {
    return _x < 10 ? 1 : 2;
    }
}