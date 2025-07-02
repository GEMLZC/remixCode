// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract A {
    function functionA() public pure virtual returns (string memory) {

        return "Function A from contract A";
    }
}


contract B is A{
    function functionA() public pure virtual override  returns (string memory) {

        return "Function B from contract B";
    }
}
constructor



contract C is A,B{
    function functionA() public pure override(A,B)  returns (string memory) {

        return "Function BA from contract BA";
    }
}