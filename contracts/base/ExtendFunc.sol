// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;


contract Base {
    event Log(string message);
    function foo() public virtual {
        emit Log("Base foo");
    }
    function bar() public virtual {
        emit Log("Base bar");
    }
}

contract F is Base{
    function foo() public virtual override {
        emit Log("F foo");
        Base.foo();
    }
    function bar() public virtual override{
        emit Log("F bar");
        super.bar();
    }
}


contract G is Base{
    function foo() public virtual override {
        emit Log("G foo");
        Base.foo();
    }
    function bar() public virtual override{
        emit Log("G bar");
        super.bar();
    }
}


contract H is F,G{
    function foo() public  override(F,G) {
        emit Log("H foo");
        F.foo();
        G.foo();
    }

    function bar() public  override(F,G){
        emit Log("H bar");
        super.bar();
    }
}
