// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

library StorageSlot {
    
    struct StringSlot {
        string value;
    }

    //赋值到指定槽
    function getStringSlot(bytes32 slot) internal pure  returns (StringSlot storage s) {

        assembly {
            s.slot := slot
        }
        
    }

}

contract TestStringSlot {
    bytes32 public constant STRING_SLOT = keccak256("test.string.slot");

    function setStringSlot(string memory newValue) public {
        StorageSlot.getStringSlot(STRING_SLOT).value = newValue;
    }

    function getStringSlot() public view returns(string memory) {
        return StorageSlot.getStringSlot(STRING_SLOT).value;
    }
}