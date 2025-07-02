// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract VisibilityBase {
     // 状态变量
    uint private  privateVar = 1;
    uint internal  internalVar = 2;
    uint public  publicVar = 3;


    // 函数
    function privateFunc() private pure returns (string memory) {
    return "Private Function";
    }
    function internalFunc() internal pure returns (string memory) {
    return "Internal Function";
    }
    function publicFunc() public pure returns (string memory) {
    return "Public Function";
    }
    function externalFunc() external pure returns (string memory) {
    return "External Function";
    }

    function testFunc() public view{
        privateVar + internalVar +publicVar;
        internalFunc();
        publicFunc();
        privateFunc();
      
    }
    
}


contract B is VisibilityBase{

    function test1() public view{
        uint internalVal = internalVar;
        uint x = publicVar;
        internalFunc();
         publicFunc();
         testFunc();
    }
}