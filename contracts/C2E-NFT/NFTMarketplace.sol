// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract NFTMarketplace is Ownable,ERC721URIStorage{
    using Counters  for Counters.Counter;
    Counters.Counter private  countId;

    constructor() Ownable(msg.sender) ERC721("NFTMarketplace","NFTM"){

    }
    
    //策展价
    uint256 public listPrice =0.01 ether;

    struct ListedToken{
        //id
        uint256 tokenId;
        //买家
        address payable owner;
        //卖家
        address payable seller;
        //售卖价格
        uint256 price;
      
        //是否已上架
        bool isListed;

        //是否运行销毁nft
        bool allow;
    
    }
    //tokenId对应的nft
    mapping(uint256 => ListedToken) public listedTokens;

        event TokenListedSuccess( 
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        bool currentlyListed);


    function updateListPrice(uint256 _listPrice) external onlyOwner{
        listPrice = _listPrice;
    }

    //创建nft
    function createToken(string memory tokenURI,uint256 price) external payable  returns(uint){
        //校验价格
        require(price > 0, "price must ge 0");
        //校验余额必须等于手续费，不能超过手续费防止多付锁死在合约中
        require(msg.value == listPrice, "need send enough list price");
        //创建代币
        countId.increment();
        uint256 _tokenId = countId.current();
        ListedToken memory listedToken = ListedToken(_tokenId,payable(msg.sender),payable(address(this)),price,true,false);
        listedTokens[_tokenId] = listedToken;
        _safeMint(msg.sender,_tokenId);
        //保存uri
        _setTokenURI(_tokenId,tokenURI);
        //把代币转到当前合约
        _safeTransfer(msg.sender,address(this),_tokenId);
        //触发事件
        emit TokenListedSuccess( 
         _tokenId,
         address(this),
        msg.sender,
        price,
        true);
        return _tokenId;
    }

    //查询全部nft
    function getAllNFTs() external view returns(ListedToken[] memory){
        ListedToken[] memory listedToken = new ListedToken[](countId.current());
        for(uint256 i=0;i<countId.current();i++){
            ListedToken memory ls = listedTokens[i+1];
            if (ls.isListed){
                listedToken[i] = ls;
            }
            
        }
        return listedToken;
    }

    //查询个人nft
    function getMyNFTs() external view returns(ListedToken[] memory){
        uint256 _tokenId = countId.current();
        uint256 index;
        for(uint256 i=0;i<_tokenId;i++){
            if ((msg.sender == listedTokens[i+1].owner || msg.sender == listedTokens[i+1].seller) && listedTokens[i+1].isListed){
                    index++;
            }
            
        }
        ListedToken[] memory listedToken = new ListedToken[](index);
        for(uint256 i=0;i<_tokenId;i++){
            if ((msg.sender == listedTokens[i+1].owner || msg.sender == listedTokens[i+1].seller) && listedTokens[i+1].isListed){
                    listedToken[i] = listedTokens[i+1];
            }
            
        }
        return listedToken;
        
    }

    //购买nft
    function executeSale(uint256 tokenId)  external payable {
        require(tokenId > 0);
        ListedToken memory listedToken = listedTokens[tokenId];
        require(listedToken.isListed,"token is not listed");
        //校验余额
        require(msg.value == listedToken.price);
        //把钱转给卖家
        payable(listedToken.seller).transfer(listedToken.price);
        //把nft转给卖家
        _safeTransfer(address(this),msg.sender,tokenId);
        payable(owner()).transfer(listPrice);
        //修改代币所有者
        listedToken.owner = payable(msg.sender);
        listedTokens[tokenId] = listedToken;

    }


    //下架nft
    function cancalOnline(uint256 tokenId) external onlyOwner{
        ListedToken storage listedToken = listedTokens[tokenId];
        require(listedToken.isListed,"token is not listed");
        listedToken.isListed = false;
        listedToken.allow = true;
    }

    function _burnNft(uint256 tokenId) external{
        ListedToken storage listedToken = listedTokens[tokenId];
        require(!listedToken.isListed && listedToken.allow,"token is not listed");
        _burn(tokenId);

    }


    function getLatestIdToListedToken() external view  returns(uint256){
        return countId.current();

    }

    function getListedTokenForId(uint256 _tokenId) external view  returns(ListedToken memory){
         return   listedTokens[_tokenId];

    }

    function getCurrentToken() external  view returns(ListedToken memory){
      return   listedTokens[countId.current()];
    }

    function getListPrice() external view  returns(uint256){
        return listPrice;
    }

    receive() external payable {
        console.log("fallback");
        //fallback
    }

}