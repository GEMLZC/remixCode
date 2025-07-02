// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract ErrorHandling {

    uint public num = 10;

    error MyError( uint i,string s);

    
    function testRequire(uint i) public pure {
        require(i < 10, "The value must be less than 10");
    }

    function testRevert(uint i) public pure {
        if (i < 10) {
            revert("Test Revert");
        }
    }

    function testAssert() external  view  {
        assert(num == 10);
    
    }


    function addNum() external  {
        num++;
    }

    function testError(uint i) external pure {
        if (i < 10) revert MyError(1,"666555");
    }

    
}
