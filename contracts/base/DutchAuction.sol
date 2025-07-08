// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
荷兰拍卖

NFT合约
拍卖合约
    卖⽅：出售 NFT
    买⽅：购买 NFT
*/

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    // NFT 相关信息
    
    IERC721  public immutable nft;
    //nft的id
    uint public immutable nftId;


    // 拍卖信息
    //拍卖起始价格
    uint public immutable startPrice;
    //拍卖持续时间
    uint private  constant DURATION = 7 days;
    //拍卖开始时间
    uint public immutable startTime;
    //拍卖结束时间
    uint public immutable endTime;
    //价格下降速率
    uint public immutable discountRate;
    //卖家地址
    address public immutable seller;
    // 卖家出售 NFT

    constructor(uint _startPrice,uint _discountRate,uint _nftId,address _nft) {
        nftId = _nftId;
        startPrice = _startPrice;
        discountRate = _discountRate;
        seller = msg.sender;
        nft= IERC721(_nft);
        startTime =  block.timestamp;
        endTime = block.timestamp + DURATION;
        require(_startPrice >=  DURATION * _discountRate, "price not enough");
    }

    // 买家购买 NFT

    function buy() external payable {
        require(block.timestamp <= endTime, "time out");
        
        //多退少不补原则 计算退款价格 当前价 = 起拍价 - 已过时间 × 折扣率
        uint price = getPrice();
        require( msg.value >=  price , "not enough value");
        nft.transferFrom(seller, msg.sender, nftId);
        uint refound = msg.value - price;
        if (refound > 0){
            payable(msg.sender).transfer(refound); 
        }
    }

    function getPrice() public view  returns(uint){
        return startPrice - (block.timestamp - startTime) * discountRate;
    }
}
    

   



