// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

interface ICounter {
    function count() external view returns (uint);
    function increment() external;
} 


contract Counter is ICounter {
    uint  public num;

    function count() external override  view  returns (uint){
        return num;
    }
    function increment() external override {
        num += 1;
    }
}

contract CallCounter {
    ICounter public immutable  c;

    constructor(ICounter _c) {
        c = _c;
    }

    function incrementCounter() external {
        c.increment();
    }

    function updateCount() external view{
        c.count();
    }
}