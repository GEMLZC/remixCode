// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
创建⼀个Solidity智能合约，名为 MessageStore ，包含以下功能：
•
⼀个公开的状态变量 message ⽤于存储⼀个字符串。
•
⼀个 setMessage 函数，允许⽤⼾输⼊⼀个字符串并将其存储到 message 状态变量中。该函数
应使⽤calldata数据位置。
•
⼀个 getMessage 函数，返回 message 状态变量的内容。该函数应声明为external，并使⽤
memory数据位置。
*/

contract MessageStore {
    string public message;

    function setMessage(string calldata s) external {
        message = s;
    }


    function getMessage() external view returns(string memory) {
        return message;
    }
}