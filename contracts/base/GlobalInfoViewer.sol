// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract GlobalInfoViewer{

    function viewGlobalInfo() external view returns (address,uint,uint){
        address owner = msg.sender;
        uint blockNum = block.number;
        uint blockTimestamp = block.timestamp;
        return (owner,blockNum,blockTimestamp);
    }
}