// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
任务：编写⼀个Solidity智能合约，实现⼀个简单的订单处理系统。
◦
声明⼀个名为 OrderStatus 的枚举，包括状态： None , Pending , Shipped ,
Completed ,Rejected , Cancelled 。
◦
创建⼀个结构体 Order ，包含买家地址和订单状态。
◦
实现功能：
i. 添加新订单到数组。
ii. 更新订单状态。
iii. 获取特定订单的状态。
iv. 重置订单状态到默认值。
*/

contract EnumTest {
    enum OrderStatus {None, Pending,Shipped,Completed,Rejected,Cancelled }

    struct Order{
        address addr;
        OrderStatus status;
    }

    modifier checkArrayOut(uint index){
        require(index <= orders.length - 1, "array out");
        _;
    }

    Order[] public orders;

    function addOrder(address addr,OrderStatus status) external {
        orders.push(Order(addr,status));
    }

    function updateOrderStatus(uint index,OrderStatus status) external checkArrayOut(index) {
        orders[index].status = status;
    }

    function getOrderStatus(uint index ) external checkArrayOut(index) view returns(OrderStatus){
           return orders[index].status;
    }

    function restOrderStatus(uint index) external checkArrayOut(index) {
        delete orders[index].status;
    }

}