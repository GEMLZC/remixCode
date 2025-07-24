// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SignUtil {
    
    using MessageHashUtils for bytes32;
    using ECDSA for bytes32;

    //恢复签名数据
    function recover(string memory str, bytes  memory signature) external returns(address) {
        bytes32 hash = keccak256(bytes(str));
        return hash.toEthSignedMessageHash().recover(signature);
    }
}
