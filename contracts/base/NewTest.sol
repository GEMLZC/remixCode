// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;


contract Account {
    address public  owner;
    
    constructor(address addr) payable{
        owner = addr;
    }

}


contract AccountFactory {
    Account[] public accounts;

    function createAccount(address addr) public payable  {
        accounts.push(new Account{value:111}(addr));
    }
 
}