// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
任务：实现⼀个Solidity合约，其中包括上述的 balances , keys ,和 inserted 数据结构，
    以及 set , getSize ,和⼀个能够根据索引返回余额的函数。
a. 使⽤Solidity 0.8编写合约。
b. 实现⼀个 set 函数，⽤于向 balances 添加或更新条⽬，并处理 keys 和 inserted 。
c. 实现 getSize 函数返回当前 keys 数组的⻓度。
d. 实现函数，根据传⼊的索引返回相应地址的余额。
*/
contract IterableMapping {
    //地址和余额映射
    mapping(address => uint256)  public balances;
    //该映射判断当前地址有无插入过，防止重复插入
    mapping(address => bool)  public inserted;
    //创建一个address数组保存key方便迭代
    address[] private keys;
   

   function set(address addr,uint monery) external {
        balances[addr] = monery;
        if (!inserted[addr]){
            keys.push(addr);
            inserted[addr] = true;
        }
        
       
   }

   function getSize() external view returns (uint) {
         return keys.length;
   }

    function getBalances(address key) external view returns (uint){
        return balances[key];
    }


    function frist() external virtual view returns (uint) {
        return balances[keys[0]];
    }

    function last() external virtual view returns (uint) {
        return balances[keys[keys.length - 1]];
    }

}