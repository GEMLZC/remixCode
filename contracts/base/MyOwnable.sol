// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract testPayable {
    
   address public owner;

   int public count;

    //部署的时候获取当前合约地址
   constructor() {
    owner = msg.sender;
   }

   modifier onlyOwner{
        require(owner == msg.sender, "You are not the owner");
        _;
   }


   function transferOwnership(address x)  public onlyOwner {
        require(x != address(0), "Cannot be the zero address");
        owner = x;
   }

   function anyFunc() public{

        count++;
        if (owner == msg.sender) count = 0;
   }
}