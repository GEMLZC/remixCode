// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**多签钱包*/
contract MultiSigWallet {
    //当以太币存⼊钱包时触发
    event Deposit(address indexed sender, uint amount);
    //当提交交易时触发
    event Submit( uint indexed txId);
    //当交易被批准时触发
    event Approve(address indexed owner, uint indexed txId);
    //当交易被执⾏时触发
    event Revoke(address indexed owner, uint indexed txId);
    //当批准被撤销时触发
    event Execute(uint indexed txId);

    //包含交易⽬标地址、发送⾦额、交易数据和执⾏状态
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }


    //存储所有者地址的数组
    address[] public owners;

    //检查某地址是否为所有者的映射
    mapping(address => bool) public isOwner;

    //执⾏交易所需的最少批准数
    uint public required;

    //存储所有交易的数组
    Transaction[] transaction;
    //存储每个交易被每个所有者批准情况的映射
    mapping(uint => mapping(address => bool)) public approved;

    /**
        初始化所有者数组和所需的批准数
        确保所有者地址有效且唯⼀
        设置状态变量
    */
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0 , "owners require");
        require(_required >0 && _required <= _owners.length, "invalied required number");
        for (uint i=0; i < _owners.length; i++) {
            address addr = _owners[i];
            require(addr != address(0), "address is 0");
            //只有false状态地址才可以设置
            require(!isOwner[addr], "owner is not unique");
            owners.push(_owners[i]);
            isOwner[addr] = true;
        }
        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
     }

     modifier onlyOwner(){
        require(isOwner[msg.sender], "not owner");
        _;
     }

     //使⽤ txExists 、 notApproved 和 notExecuted 修饰符确保交易存在、未被批准且未被执⾏

     modifier txExists(uint _txId){
        require(_txId < transaction.length, "tx does not exist");
        _;
     }

     modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender],"already approved");
        _;
     }

     modifier notExecuted(uint _txId){
        require(!transaction[_txId].executed, "tx already executed");
        _;
     }


    //提交新交易。
     function submit(address _to, uint _value, bytes calldata _data) onlyOwner external {
        transaction.push(Transaction(_to,_value , _data,false));
        emit Submit(transaction.length - 1);
     }

     //批准交易
      function approve(uint _txId) onlyOwner txExists(_txId) notApproved(_txId)  notExecuted(_txId) external {
            approved[_txId][msg.sender] = true;
            emit Approve(msg.sender, _txId);
      }

      //执行交易
      function execute(uint _txId) onlyOwner txExists(_txId) notApproved(_txId)  notExecuted(_txId) external {
            require(_getApprovalCount(_txId) < required, "not enough approvals");
            Transaction storage t = transaction[_txId];
            t.executed = true;

            (bool success, ) = t.to.call{value: t.value}(t.data);
            require(success, "execute failed");
            emit Execute(_txId);
      }


      function _getApprovalCount(uint _txId) private view returns(uint) {
        uint count;
            for (uint i ; i < owners.length; i++){
                    if (!approved[_txId][owners[i]]){
                            count++;
                    }
            }
        return count;
      }
}