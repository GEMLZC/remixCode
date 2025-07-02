// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract count {
   int public num;
   string public constant s = "1230";
   int64  public immutable x = 9865;
   int public i1;

   constructor() {
        num = 0;
   }

   function inc() external {
        num += 1;
   }

   function dec() external  {
        num -= 1;
   }

   function test() public {
     //调用外部函数
     this.inc();
   }

   function test2(int a,int b) external returns (int c){
     i1 = a+b;
     return i1;
   }
}

