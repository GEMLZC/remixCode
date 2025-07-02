// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

contract S {

    string public  name;

    constructor(string memory _name){
        name = _name;
    }
}


contract T {

    string public  text;

    constructor(string memory _text){
        text = _text;
    }
}


contract U is S,T{

    constructor(string memory _text,string memory _name) S(_name) T(_text){
       
    }
}


contract TT is S("s"),T{

    constructor(string memory _text,string memory _name) T(_text){
       
    }
}


contract B0 is S("bs"),T("bt"){

    constructor(string memory _text,string memory _name){
       
    }
}

contract B1 is T("b1t"),S("b1s"){

    constructor(string memory _text,string memory _name){
       
    }
}
