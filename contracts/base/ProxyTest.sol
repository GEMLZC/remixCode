// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.23;

library StorageSlot {
    
    struct StringSlot {
        string value;
    }

    //赋值到指定槽
    function getStringSlot(bytes32 slot) internal pure  returns (StringSlot storage s) {

        assembly {
            s.slot := slot
        }
        
    }

}

library AddressSlot {
    
    struct AddrSlot {
        address value;
    }

    //赋值到指定槽
    function getAddressSlot(bytes32 slot) internal pure  returns (AddrSlot storage a) {

        assembly {
            a.slot := slot
        }
        
    }

}

contract TestStringSlot {
    bytes32 public constant STRING_SLOT = keccak256("test.string.slot");

    function setStringSlot(string memory newValue) public {
        StorageSlot.getStringSlot(STRING_SLOT).value = newValue;
    }

    function getStringSlot() public view returns(string memory) {
        return StorageSlot.getStringSlot(STRING_SLOT).value;
    }
}


// 1. 重现透明可升级代理，并探讨其错误实现。
// 2. 视频系列内容：
// - 错误实现可升级代理合约,分析错误实现中的问题
// - 返回回退函数中的数据 fallback
// - 在智能合约的存储槽中写⼊任意数据
// - 存储实现合约地址和admin地址
// - 分离admin和user接⼝
// - proxy admin合约
// - 实际操作演⽰
contract Proxy {
    bytes32 private constant IMPLEMENTATION_SLOT = bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 private constant ADMIN_SLOT = bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);


    //address public implementation;
    //address public admin;

    constructor() {
        setAdmin(msg.sender);
    }

    modifier ifAdmin(){
        if(msg.sender == getAdmin()){
            _;
        }else{
            delegatecallProxy();
        }
    }

    function upgradeTo(address _newImplementation) external ifAdmin{
        require(_newImplementation.code.length > 0, "not a contract");
        setImplementation(_newImplementation);
    }
    fallback() external payable {
        delegatecallProxy();
    }

    receive() external payable { 
        delegatecallProxy();
    }
    

    function delegatecallProxy() internal {
        address _impl = getImplementation();
        require(_impl != address(0), "Implementation contract not set");
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }


    function setAdmin(address newValue) private {
        require(newValue != address(0) , "not a contract");
        AddressSlot.getAddressSlot(ADMIN_SLOT).value = newValue;
    }

    function getAdmin() private  view returns(address) {
        return  AddressSlot.getAddressSlot(ADMIN_SLOT).value;
    }


    function setImplementation(address newValue) private {
        require(newValue.code.length > 0 , "not a contract");
        AddressSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = newValue;
    }

    function getImplementation() private  view returns(address) {
        return AddressSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function admin() external ifAdmin returns (address a) {
        return getAdmin();
    }
    function implementation() external ifAdmin returns (address a) {
        return getImplementation();
    }

    function changeAdmin(address newAdmin) external ifAdmin{
        setAdmin(newAdmin);
    }
    

}

contract ProxyAdmin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only admin can do this");
        _;
    }

    function changeProxyAdmin(address payable proxy,address _admin) external onlyOwner{
        require(proxy != address(0), "Not a contract");
        Proxy(proxy).changeAdmin(_admin);
    }

    function getProxyAdmin(address proxy) external view returns(address a){
        (bool success,bytes memory res) = proxy.staticcall(
            abi.encodeCall(Proxy.admin,())
        );
        require(success, "staticcall fail");
        return abi.decode(res, (address));
    } 


    function getProxyImplementation(address proxy) external view returns(address a){
        (bool success,bytes memory res) = proxy.staticcall(
            abi.encodeCall(Proxy.implementation,())
        );
        require(success, "staticcall fail");
        return abi.decode(res, (address));
    } 

    function upgrade(address payable proxy,address implementation) external onlyOwner{
         require(proxy != address(0), "Not a contract");
          Proxy(proxy).upgradeTo(implementation);
    }
    
}


// Counter V1
contract CounterV1 {
    uint256 public count;
    function inc() public {
        count += 1;
    }

    function admin() public pure returns(address) {
        return address(1);
    }

    function implementation() public pure  returns(address) {
        return address(12);
    }
}
// Counter V2
contract CounterV2 {
    uint256 public count;
    function inc() public {
        count += 1;
    }
    function dec() public {
        count -= 1;
    }
}




