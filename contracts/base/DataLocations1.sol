// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;
/**
实现⼀个简单的智能合约，包括以下功能：
•
定义⼀个struct，包含⼀个字符串和⼀个整数数组。
•
实现两个函数：
a. ⼀个函数⽤于修改struct的字符串成员，该函数的参数为字符串，使⽤storage存储数据位置。
b. 另⼀个函数⽤于读取struct的整数数组成员，该函数的参数为整数数组，使⽤calldata存储数据
位置，且在函数内部调⽤时，参数也使⽤calldata存储位置。
*/

contract DataLocations {
    

    struct MyStruct{
        string str;
        uint[] arr;
    }

    mapping(address => MyStruct) public structs; 


    function test1(string memory s) external {
        MyStruct storage m = structs[msg.sender];
        m.str = s;
    }


    function test2(uint[] calldata arr,uint index) private  pure  returns (uint){
        return arr[index];
    }

    function test3(uint[] calldata arr,uint index) external pure returns (uint){
        return test2(arr,index);
    }

}