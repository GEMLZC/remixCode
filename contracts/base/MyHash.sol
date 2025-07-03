
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract SignatureVerification {
    
    function verify(address sender, string memory _msg,bytes memory sig) public pure returns (bool){
            bytes32 messagesHash = getMessageHash(_msg);
            bytes32 ethSignedMessageHash = getEthSignedMessageHash(messagesHash);
    
            return recover(ethSignedMessageHash,sig) == sender;
    }

    function getMessageHash(string memory _msg ) public pure returns (bytes32){
        return keccak256(abi.encode(_msg));
    }


    function getEthSignedMessageHash(bytes32 messagesHash ) public pure returns (bytes32){
        return keccak256(abi.encode("\x19Ethereum Signed Message:\n32",messagesHash));
    }


     function recover(bytes32 ethSignedMessageHash,bytes memory signature) public pure
      returns(address recoveredAddress){ 
            (bytes32 x, bytes32 y,uint8 v ) = splitSignature(signature);
            return ecrecover(ethSignedMessageHash,v,x,y);
     }


     function splitSignature(bytes memory signature) public pure returns (bytes32 x, bytes32 y,uint8 v ){
        require(signature.length == 65, "Invalid signature length");
        assembly {
            x := mload(add(signature, 32))
            y := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
     }

}