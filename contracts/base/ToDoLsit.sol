
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;
/**
任务：编写⼀个Solidity程序，实现⼀个简单的待办事项列表。
要求：
a. 定义⼀个 ToDo 结构体，包含 text （任务描述）和 completed （是否完成）。
b. 创建⼀个 ToDo[] 数组来存储多个任务。
c. 实现 create , updateText ,和 toggleCompleted 函数。
d. 部署合约到测试⽹络，并通过界⾯或命令⾏测试各个函数的功能。
*/

contract ToDoLsit {
    
    struct ToDo{
        string text;
        bool completed;
    }

    ToDo[] public list;

    function create(string calldata _text,bool _completed) external {
        list.push(ToDo(_text,_completed));
    }

    function updateText(uint  index,string calldata _text) external {
        //更新少量字段用索引直接更新，批量需要去除结构体再更新 省gas
        list[index].text = _text;
    }

    function toggleCompleted(uint  index) external {
        // 
        list[index].completed = !list[index].completed;
    }


}