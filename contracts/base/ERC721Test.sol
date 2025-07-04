// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

interface IERC165 {

    /**
        作用场景：
        当合约A需要调用合约B的特定功能（如转账、查询余额）时，
        可先通过supportsInterface检查合约B是否支持相关接口（如ERC20、ERC721），避免调用失败。

        实际应用场景
        1. ​DeFi协议集成
        钱包或交易所调用supportsInterface检测代币合约是否兼容ERC20，以决定是否展示余额或支持交易。
        2. ​NFT市场
        交易平台通过检查IERC721Receiver接口（ID：0x150b7a02），确认目标合约能否安全接收NFT，避免资产锁定。
        3. ​可升级合约
        代理合约在升级后，调用方需验证新逻辑合约是否支持原有接口，确保兼容性
    */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}

interface IERC721 is IERC165 {

    //在代币被转移时触发
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    //在一个地址被授权管理另一个地址的特定代币时触发
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    //当一个操作者被授权或取消授权管理某个所有者的所有代币时触发
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);


    /**
        描述：返回指定地址所拥有的代币数量
        参数：_owner：代币拥有者的地址
        返回值：该地址拥有的代币数量
    */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
        描述：查询某个代币的所有者
        参数：_tokenId：代币的唯一识别 ID
        返回值：拥有此代币的地址
    */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
        描述：安全地将代币从一个地址转移到另一个地址，调用时会检查接收者地址是否具备处理 ERC721 代币的能力
        参数：
        _from：当前代币的拥有者地址
        _to：代币将要被转移至的目标地址
        _tokenId：将要被转移的代币的 ID
        data：额外的数据，可能会在调用中使用
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
        描述：将代币从一个地址转移到另一个地址，不检查接收者地址是否能处理 ERC721 代币
        参数：
        _from：当前代币的拥有者地址
        _to：代币将要被转移至的目标地址
        _tokenId：将要被转移的代币的 ID
    */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
    描述：授权某个地址管理特定的ERC721代币
    参数：
    _approved：被授权的地址
    _tokenId：代币的唯一识别 ID
*/
    function approve(address to, uint256 tokenId) external;

    /**
        描述：获取被授权管理特定代币的地址
        参数：_tokenId：代币的唯一识别 ID
        返回值：被授权的管理该代币的地址
    */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
        描述：将一个操作者地址设置为被批准或取消批准管理所有代币的权利
        参数：
        _operator：操作者的地址
        _approved：批准或取消批准的标志
    */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
        描述：查询一个操作者是否被批准管理某个所有者的所有代币
        参数：
        _owner：代币拥有者的地址
        _operator：操作者的地址
        返回值：是否被授权的布尔值
    */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

     /**
        描述：安全地将代币从一个地址转移到另一个地址，调用时会检查接收者地址是否具备处理 ERC721 代币的能力
        参数：
        _from：当前代币的拥有者地址
        _to：代币将要被转移至的目标地址
        _tokenId：将要被转移的代币的 ID
        data：额外的数据，可能会在调用中使用
    */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

}



interface IERC721Receiver {

    /**
        触发条件
    当 NFT 通过 ​**safeTransferFrom** 方法（而非普通 transferFrom）转移至合约地址时，
    接收方合约必须实现 onERC721Received 函数。
     ​成功场景：目标合约实现该函数并返回正确值 → NFT 转账成功。
     ​失败场景：未实现或返回值错误 → ​交易回滚，NFT 不会转移

     若接收合约未实现此接口，NFT 转入后可能因缺乏转出逻辑而被永久锁定（如 PeopleDAO 曾因类似错误损失 4000 万代币）。
     onERC721Received 通过强制验证，从协议层规避此类风险。
    */
    function onERC721Received(
        address operator,   // 执行转账操作的地址（用户或代理合约）
        address from,       // NFT 转出方地址
        uint256 tokenId,    // 转移的 NFT 唯一标识
        bytes calldata data // 自定义数据（可选）
) external returns (bytes4);

}


/**

​授权：
单个授权：调用approve，设置单个代币的授权地址。
批量授权：调用setApprovalForAll，设置操作者的批量授权状态。

​转账：
普通转账：调用transferFrom，直接转账，不检查接收方。
安全转账：调用safeTransferFrom（两种形式），在转账后检查接收方是否为合约且实现了onERC721Received。

​查询：
查询余额：balanceOf
查询所有者：ownerOf
查询单个授权：getApproved
查询批量授权：通过公共映射isApprovedForAll自动生成的getter函数。
*/

contract ERC721 is  IERC721{
    //记录地址的代币数量
    mapping(address =>uint256 )  balances;
    //记录代币的地址
    mapping(uint256=>address ) _owners;
    //授权代币地址标识
    mapping(address => mapping(address => bool)) override  public isApprovedForAll;
    //授权代币地址
    mapping(uint256=>address) _approves;


     function supportsInterface(bytes4 interfaceId) override  external pure  returns (bool){
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
     }


     /**
        描述：返回指定地址所拥有的代币数量
        参数：_owner：代币拥有者的地址
        返回值：该地址拥有的代币数量
    */
    function balanceOf(address owner) override external view returns (uint256 balance){
        require(owner != address(0),"ERC721: address zero is not");
        return balances[owner];
    }


     /**
        描述：查询某个代币的所有者
        参数：_tokenId：代币的唯一识别 ID
        返回值：拥有此代币的地址
    */
    function ownerOf(uint256 tokenId) override public  view returns (address owner){
            address adder = _owners[tokenId];
            require(adder != address(0), "address zero is not");
            return adder;
    }


    function safeTransferFrom(address from, address to, uint256 tokenId) override external{
        transferFrom(from, to, tokenId);
        require(to.code.length == 0 ||
        IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") ==
        IERC721Receiver.onERC721Received.selector,"unsafe recipient");
    }


    /**
        描述：安全地将代币从一个地址转移到另一个地址，调用时会检查接收者地址是否具备处理 ERC721 代币的能力
        参数：
        _from：当前代币的拥有者地址
        _to：代币将要被转移至的目标地址
        _tokenId：将要被转移的代币的 ID
        data：额外的数据，可能会在调用中使用
    */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) override external{
        transferFrom(from, to, tokenId);
        require(to.code.length == 0 || 
        IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) == 
        IERC721Receiver.onERC721Received.selector
        , "unsafe recipient");
    }


    /**
        描述：将代币从一个地址转移到另一个地址，不检查接收者地址是否能处理 ERC721 代币
        参数：
        _from：当前代币的拥有者地址
        _to：代币将要被转移至的目标地址
        _tokenId：将要被转移的代币的 ID
    */
    function transferFrom(address from, address to, uint256 tokenId) override  public {
        require(from != address(0) && to != address(0), "address or toAddress zero is not");
        require(tokenId != 0, "tokenId zero");
        require(from == _owners[tokenId], "owner of tokenId not match fromAddress ");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authrized");

        balances[from]--;
        balances[to]++;
        _owners[tokenId] = to;
        delete _approves[tokenId];
        emit Transfer(from, to, tokenId);
    }

    //判断调用者拥有代币操作的权限
    function _isApprovedOrOwner(address owner ,address spender,uint256 tokenId) internal view  returns(bool) {
        return owner == spender || _owners[tokenId] == spender || isApprovedForAll[owner][spender];
    }

    /**
    描述：授权某个地址管理特定的ERC721代币
    参数：
    _approved：被授权的地址
    _tokenId：代币的唯一识别 ID
*/
    function approve(address to, uint256 tokenId) override external{
            address owner =  _owners[tokenId];
            require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "not authorized");
            _approves[tokenId] = to;
            emit Approval(owner,to,tokenId);
    }


    /**
        描述：获取被授权管理特定代币的地址
        参数：_tokenId：代币的唯一识别 ID
        返回值：被授权的管理该代币的地址
    */
    function getApproved(uint256 tokenId) override external view returns (address operator){
        require(_owners[tokenId] != address(0), "ERC, address is  0");
        return _approves[tokenId];
    }

    /**
        描述：将一个操作者地址设置为被批准或取消批准管理所有代币的权利
        参数：
        _operator：操作者的地址
        _approved：批准或取消批准的标志
    */
    function setApprovalForAll(address operator, bool _approved) override external{
        require(operator != address(0), "operator address is  0");
        isApprovedForAll[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender,operator,_approved);
    }


    //创造代币
    function _mint(address to, uint tokenId) internal {
        require(to != address(0), "to = zero address");
        balances[to]++;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    //销毁代币
    function _burn(uint tokenId) internal{
       address owner =  ownerOf(tokenId);
       require(owner != address(0), "address is  zero");
       balances[owner]--;
       //去掉代币授权的地址
       delete _approves[tokenId];
       //去掉代币的地址
       delete _owners[tokenId];
    }
}


contract MyNFT is ERC721 {
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }
    function burn(uint tokenId) external {
        require(msg.sender == _owners[tokenId], "not owner");
        _burn(tokenId);
    }

}