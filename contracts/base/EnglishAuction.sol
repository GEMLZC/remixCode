// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
英式拍卖
英式拍卖（English Auction）是⼀种常⻅的拍卖形式，拍卖开始于⼀个最低价格或起拍价，竞
标者根据⾃⼰的意愿竞价，且每次出价必须⾼于前⼀个出价，直到没有⼈愿意再加价为⽌。
最终，出价最⾼的竞标者赢得拍卖品。此种拍卖形式竞争激烈，持续时间较⻓，常⻅于艺术
品、古董、房产等⾼价值物品的拍卖。


NFT合约
拍卖合约（英式拍卖）
        发起拍卖（卖⽅）
        竞价（买⽅）
        提款（买⽅）
        结束拍卖（买⽅/卖⽅）
*/

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}


contract EnglishAuction {
    
    //NFT合约信息
    IERC721 public immutable nft;
    uint public immutable nftId;

    //拍卖合约信息
    //卖家地址
    address payable public immutable seller; 
    //买家地址
    address private buyAddress;  
    //买家出价
    uint private buyPrice;
    //起拍价
    uint public startPrice;
    //开始时间
    uint public startTime;

    //结束时间
    uint public endTime;
    //拍卖持续时间
    uint public duration = 60; 
    //未成功竞拍的买家退款余额
    mapping(address => uint) public refundAmount;
    //拍卖状态（开始、结束）
    bool public startState;
    bool public endState;
    //竞拍事件
    event Bid(address indexed buyAddress,uint buyPrice,uint total);
    //发起拍卖事件
    event Start(address _seller ,uint nftId,uint startTime,uint endTime);
    event End();

    // 发起拍卖（卖⽅）
    constructor(uint _startPrice,uint _nftId,address _nft) {
        nft = IERC721(_nft);
        nftId = _nftId;
        startPrice = _startPrice;
        buyPrice = _startPrice;
        seller = payable(msg.sender);
        
    }


    // 卖家发起拍卖
    function start() external {
        require(msg.sender == seller, "Must be seller");
        startState = true;
        startTime = block.timestamp;
        endTime = startTime + duration;
        nft.transferFrom(seller, address(this), nftId);
        emit Start(address(this),nftId,startTime,endTime);
    }


    //竞价（买⽅）
    function bid() external payable {
       require(startState, "Didn't start");
       require(block.timestamp >= startTime && block.timestamp <= endTime,"Not allowed to bid anymore!");
       require(msg.value > buyPrice , "not enough ETH!");
       buyAddress = msg.sender;
       buyPrice = msg.value;
       refundAmount[buyAddress] += msg.value;
       emit Bid(buyAddress,buyPrice,refundAmount[buyAddress]);
    }

    //提款（买⽅）
    function withdraw() external {
        require(!startState, "starting");
        require(block.timestamp > endTime, "The auction has ended");
        uint _refundAmount = refundAmount[msg.sender];
        if(_refundAmount != 0){
            payable(msg.sender).transfer(_refundAmount);
            refundAmount[msg.sender] = 0;
        }
    }


    //结束拍卖（买⽅/卖⽅）
    function end() external {
         require(block.timestamp > endTime, "The auction has ended");
         require(startState, "The auction has ended");
         require(!endState, "the auction has been ended!");

         endState = true;
         startState = false;

         if (buyAddress != address(0)){
            seller.transfer(buyPrice);
            nft.transferFrom(address(this),buyAddress, nftId );
         }else{
            nft.transferFrom(address(this),seller, nftId );
         }
         emit End();
    }
       
}