// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract Caller {
    uint public num;
    event Log(bool caller, bytes data);
    
    function setCallerNum(address addr,uint  _num) external {
       (bool success,bytes memory data) =  addr.delegatecall(abi.encodeWithSelector(Callee.setNum.selector, _num));
        emit Log(success, data);
    }
}


contract Callee {
    uint public num;

    function setNum(uint _num) external {
        num = _num;
    }
    
}