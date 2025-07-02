// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract MyCallerContract {
    function setTargetX(MyTargetContract _m,uint _x) external {
        _m.setX(_x);
    }


    function getTargetX(MyTargetContract _m) external view returns(uint)  {
        return _m.getX();
    }

    function getTargetX2(address addr) external view returns(uint)  {
        return MyTargetContract(addr).getX();
    }

    function setXWithEther(MyTargetContract _m,uint _x) external payable {
        _m.setXAndReceiveEther{value : msg.value}(_x);
    }

    function getXAndValueFromTarget(MyTargetContract _m) external view returns (uint256 x, uint256 y) {
        (x,y) = _m.getXAndValue();
    }

}

contract MyTargetContract {
    uint private x;
    uint private value;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns(uint)  {
        return x;
    }


    function setXAndReceiveEther(uint256 _x) external payable {
        x =_x;
        value = msg.value;
    }


    function getXAndValue() external view returns (uint256, uint256) {
        return (x, value);
    }
}