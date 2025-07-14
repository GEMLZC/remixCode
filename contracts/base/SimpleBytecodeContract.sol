// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract Factory {
    event Log(address addr);
    function deploy() external {
        bytes memory bytecode = hex"600a600c600039600a6000f3602a605260005260206000f3";
        address addr;
        assembly {
            addr := create(0, add(bytecode, 32), mload(bytecode))
        }
        require(addr != address(0), "Deploy failed");
        emit Log(addr);
    }
}


interface IDeployedContract {
    function getMeaningOfLife() external view returns (uint);
}


contract DeployedContract is IDeployedContract{
    function getMeaningOfLife() override  external view returns (uint){
        return 42;
    }
}