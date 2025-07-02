// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract functionTest{
  uint public count = 1;

  uint256 public constant A = 256;
  bool public testBool =  true;
  int public constant A_ = -128;

  function test1() view public returns (uint){
    return count;
  }

  function test2() pure public returns (uint) {
    return 1 ;
  }

  function test3() payable public returns(uint) {
    return 1;
  }

}
