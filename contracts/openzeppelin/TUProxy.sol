// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract TUProxy is TransparentUpgradeableProxy{
    

     constructor(address _logic, address initialOwner, bytes memory _data) payable TransparentUpgradeableProxy(_logic,initialOwner, _data) {
      
    }


    function proxAdmin() external view returns(address) { 
        return _proxyAdmin(); 
    }


    function getImplements() external view returns(address) { 
        return _implementation(); 
    }


}