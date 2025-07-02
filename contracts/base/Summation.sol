// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract Summation{

    // 定义⼀个函数来计算从1到n的累加和
    function sum(uint n) external pure returns (uint) {
        uint total = 0;
      
          for (uint i = 1; i <= n; i++) {
            total += i;
            continue;
        }
        return total;
    }


     function sum2(uint n) external pure returns (uint) {
        uint total = 0;
        uint i =1;
        while (i <=n ) 
        {
           total += i;
           i++;
        }
        return total;
    }
}