
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
Solidity0.8中默认启⽤的溢出和下溢检查
禁⽤这些检查可以节省Gas费⽤
*/
contract UncheckedMath {
    function add(uint256 x, uint256 y) external pure returns (uint256) {
        // 947
        //return x + y;
        // 759
        unchecked {
        return x + y;
        }
    }
    function sub(uint256 x, uint256 y) external pure returns (uint256) {
        // 380
        return x - y;
        // 284
        // unchecked {
        // return x - y;
        // }
    }
    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {
        unchecked {
            uint256 x3 = x * x * x;
            uint256 y3 = y * y * y;
            return x3 + y3;
        }
    }

}