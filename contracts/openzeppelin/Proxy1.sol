// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
contract Proxy1 is Initializable {
    uint public x;

    
     function initialize(uint256 initialValue) public initializer {
        x = initialValue;
    }

    function count() external  {
        x += 1;
    }

   
   function showInvock() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.initialize.selector,1);
   }
}