// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.23;

//部署新合约后，⽐较预计算的地址和实际部署的地址
contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner =_owner;
    }
}

contract Create2Factory {
    event Deploy (address addr);

    //Create1
    function deploy(uint _salf) public returns (address instance){
        DeployWithCreate2 d = new DeployWithCreate2{
            salt: bytes32(_salf)

        }(msg.sender);
        emit Deploy(address(d));
        return address(d);
    }
  
    function getAddress(bytes memory bytecode, uint _salt) public view returns(address){
        bytes32 hash = keccak256(
        abi.encodePacked(
        bytes1(0xff),address(this), _salt, keccak256(bytecode)
        )
        );
        // 20/32 = 0.625
        // 160 / 256 = 0.625
        return address(uint160(uint256(hash)));
    }

    function getBytecode(address _owner) public pure returns(bytes memory) {
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}