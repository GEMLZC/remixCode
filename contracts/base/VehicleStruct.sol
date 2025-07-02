// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
编程作业：创建⼀个Solidity智能合约，包含⼀个名为 Vehicle 的struct，具有以下属性：
 make (制造商，字符串类型)， year (⽣产年份，整数类型)，
 和 owner (所有者，地址类型)。合约应允许

⽤⼾：
•
添加新的⻋辆到数组中。
•
访问和修改特定⻋辆的年份。
删除⻋辆记录。
*/
contract VehicleStruct {
    struct Vehicle{
        string make;
        uint year;
        address owner;
    }

    Vehicle[] public car; 

    function addCar(string memory m,uint y,address o) external {
        car.push(Vehicle(m,y,o));
    }

    function addCar2(Vehicle memory v) external {
        car.push(v);
    }

    function delCar(uint index) external {
    
        require(index <= car.length - 1, "array out");
        delete car[index];
       
    }

    function getCar(uint index) external view  returns (Vehicle memory){
        require(index <= car.length - 1, "array out");
        return car[index];
    }

    function updateCarYear(uint index,uint y) external{
            require(index <= car.length - 1, "array out");
            Vehicle storage v =  car[index];
            v.year = y;
    }

}