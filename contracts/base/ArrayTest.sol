// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract ArrayTest {
    uint[] private nums = [1,2,3];
    uint[3] private fixedNums = [4,5,6];

    modifier checkDynArrayOut(uint index){
        require(index <= nums.length - 1,"The array is out of bounds");
        _;
    }

    function addEle(uint i) public {
        nums.push(i);
        //uint[] memory a = new uint[](5);
        //delete a[1];
    }

    function getDynArrEle(uint index) public checkDynArrayOut(index) view returns(uint){
        return nums[index];
    }


    function updateDynArrEle(uint index,uint newVal) public checkDynArrayOut(index){
        nums[index] = newVal;
    }

    function getDynArrLen() public view returns (uint){
        return nums.length;
    }


    function deleteEle(uint index) public checkDynArrayOut(index){
        if(index == nums.length - 1 ){
            nums.pop();
        }else{
            nums[index] = nums[nums.length - 1];
            nums.pop();
        }
    }

    //gas太贵极度不建议使用
    function getDyn() public view returns (uint[] memory arr){
        arr = nums;
    }
}