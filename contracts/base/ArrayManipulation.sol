// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;
contract ArrayManipulation {
    
    function remove(uint[] memory arr,uint index) public pure  returns (uint[] memory){
        require(arr.length > 0, "array length must be greater than zero.");
        require(index > 0 && index <= arr.length, "Invalid Index");
        if (index != arr.length - 1){
          arr[index] = arr[arr.length - 1];
        }
        uint[] memory newArr = new uint[](arr.length - 1);
        for (uint j = 0; j < newArr.length; j++) {
           newArr[j] = arr[j];
        }
        return newArr;
    }



    function efficientRemove(uint[] memory arr, uint index) public pure returns(uint[] memory) {

        require(index < arr.length, "Index out of bounds");

        arr[index] = arr[arr.length - 1];

        uint[] memory newArr = new uint[](arr.length - 1);

        for (uint i = 0; i < newArr.length; i++) {

            newArr[i] = arr[i];

        }
        return newArr;
    }
}