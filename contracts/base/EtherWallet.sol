// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable { }

    function withdraw(uint  amont) external payable {
        require(msg.sender == owner,"Caller is not owner");
        payable((msg.sender)).transfer(amont);
    }


    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
}