// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.23;


contract Receiver {
    
    event Log(bytes data);
    //0xa9059cbb
    //0000000000000000000000006eef01557ae461a863c6214a96b0dd872601b53d
    //0000000000000000000000000000000000000000000000000000000000000001
    function transfer(address _to, uint256 _amount) external {
    emit Log(msg.data);
    }
}

contract FunctionSelector{

    function getSelector(string calldata funcStr) external pure  returns (bytes4) {
        //return bytes4(keccak256(abi.encodePacked("transfer(address,uint256)")));//0xa9059cbb
       return bytes4(keccak256(bytes(funcStr)));//0xa9059cbb
    }
}