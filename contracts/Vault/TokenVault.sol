// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC4626.sol";

contract TokenVault is ERC4626 {
    //用户地址对应的份额
    mapping(address => uint256) shareHolder;

        constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC4626(_asset, _name, _symbol) {}

    //返回金库合约的余额
    function totalAssets() override  public view  returns (uint256){
        return asset.balanceOf(address(this));
    }


    //返回用户的资产
    function totalAssetsOfUser(address user)  public view  returns (uint256){
        return asset.balanceOf(user);
    }
    

    function _deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
        require(receiver != address(0),"receiver not 0");
        shares = deposit(assets,receiver);
        //增加当前用户地址的份额
        shareHolder[receiver] += shares;
    }
}