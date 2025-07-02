// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract MultipleOutputs {
    uint private  number;
    bool private flag;
    string private text;

    function returnMultiple() public pure  returns (uint n,bool b,string memory s){
        n = 1;
        b = true;
        s = "123";
    } 

    function captureOutputs() public {
        (uint num,bool f ,string memory s) = returnMultiple();
        number = num;
        flag = f;
        text = s;
    }


    function displayOutputs() public view returns( uint n, bool b ,string memory s){
        return (number,flag,text);
    }

}