// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.28;

contract Verify2 {
    uint public count;


    function verify() public view returns (uint) {
        return count;
    }
}