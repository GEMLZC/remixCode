// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UUPS is Initializable, UUPSUpgradeable, OwnableUpgradeable{
    uint256 public value;

    // 初始化函数（替代构造函数）
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    // 必须重写：定义升级权限
    function _authorizeUpgrade(address) internal override onlyOwner {}


     // 业务逻辑
    function setValue(uint256 _value) external {
        value = _value * 2;
    }
}