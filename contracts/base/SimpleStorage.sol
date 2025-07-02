// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract SimpleStorage{
    uint public storedData = 256;

    function set(uint _storedData) external  {
        storedData = _storedData;
    }

    function get() external view returns (uint){
        return storedData;
    }
}