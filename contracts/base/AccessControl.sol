// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract AccessControl {
    //0x2b5d4234a022cfb9821caf2418c4d73719f7f89f7957964f3f4d650d113d37a1
    bytes32 private  constant ADMIN = keccak256(abi.encode("ADMIN"));

    //x55e026565094d87b9053095739f9e8de176cd0013f65014214e801aedaa815ab
    bytes32 private constant USER = keccak256(abi.encode("USER"));

    mapping(bytes32 => mapping(address => bool)) public  roles;

    event RoleGranted(bytes32 roles,address account);
    event RoleRevoked(bytes32 roles,address account);

    modifier onlyRole(bytes32 role) {
        require(roles[role][msg.sender],"You dont have the required permission");
        _;
    }

    constructor() {
        _grantRole(ADMIN,msg.sender);
    }


    function _grantRole(bytes32 role,address addr) internal {
        roles[role][addr] = true;
        emit RoleGranted(role,addr);
    }

    function grantRole(bytes32 role,address addr) external  onlyRole(ADMIN){
        _grantRole(role, addr);
    }

    function _revokeRole(bytes32 role,address addr) internal {
        roles[role][addr] = false;
        emit RoleRevoked(role,addr);
    }

    function revokeRole(bytes32 role,address addr) external  onlyRole(ADMIN) {
        _revokeRole(role, addr);
    }
}