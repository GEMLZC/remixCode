// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;


library MathLib {
    
    function min(uint x,uint y) internal pure returns (uint){
        return x < y ? x : y;
    }
}

library ArrayUtils {
    function sum(uint[] memory arr) internal pure returns (uint){
        uint total = 0;
        for (uint i = 0; i < arr.length; i++) {
            total += arr[i];
        }
        return total;
    }
}

contract TestLibraries {
    using ArrayUtils for uint[] ;

    uint[] public gArr = [5,6,7];


    function test1(uint x,uint y) external pure returns (uint){
        return MathLib.min(x,y);
    }
    
    function test2() external view returns (uint){
        return gArr.sum();
    }
}