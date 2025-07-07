// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;


/**
使⽤calldata代替memory：通过改变变量存储位置来减少燃⽓消耗。
循环内部变量优化：在循环开始前将状态变量加载到内存，循环结束后再更新状态变量。
表达式短路（ShortCircuiting）：优化条件判断逻辑，避免不必要的计算。
循环增量简化：使⽤ ++i 代替 i + 1 来减少操作。
缓存数组⻓度：将数组⻓度存储在局部变量中，减少每次循环的计算量。
数组元素加载到内存：将频繁访问的数组元素预先加载到变量中。
*/
contract GasGolf {
    
    /**
        1. 使⽤上述所有燃⽓优化技术。
        2. 计算数组中所有⼩于100的偶数的和。
        3. 返回计算结果。
    */
    function optimizeGasUsage(uint[] calldata arr) external pure returns (uint) {
        uint total;
        for (uint i ; i < arr.length; ++i) 
        {
            uint num = arr[i]; 
            if (num > 10 && (num % 2 == 0 )) total += num;
        }
       return total;
    }
}