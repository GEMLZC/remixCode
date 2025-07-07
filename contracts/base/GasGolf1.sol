// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

/**

基本流程
3. ：
◦
事务队列：通过 queue 函数⼴播即将执⾏的交易。
◦
等待期：根据TimeLock合约设定的时间（从24⼩时到⼏天不等）等待。
◦
执⾏交易：等待期过后，调⽤ execute 函数执⾏交易。
4. 安全机制：提供⽤⼾响应时间以确保交易的安全性，防⽌恶意操作。
5. 合约实例：介绍 TestTimeLock 合约和 test 函数的关系及其安全特性。
*/

contract TimeLock {
    //合约入队标识，bytes32:事务id  bool:是否入队
    mapping(bytes32 => bool) public queueMapping;
    //合约所有者
    address public owner;

    uint public constant MIN_TIME = 10;
    uint public constant MAX_TIME = 1000;

    //时间范围错误
    error TimeError(address _to, uint _amont,string  funName,uint timestamp,string errorMessage);
    //队列任务未添加或者已执行
    error QueuedTxNotExist(address _to, uint _amont,string  funName,uint timestamp);
    //事务已添加
    error AlreadyQueuedError(bytes32 txId);
    //调用失败
    error CallFailError(bytes32 txId);
    //取消错误
    error CancelError(bytes32 txId);

    //事务入队事件
    event TransactionQueueing(address _to, uint _amont, string funName,uint timestamp);
    //事务调用成功
    event TransactionExecuteSuccess(bytes32 txId);

    //取消事务成功
    event CancelSuceess(bytes32 _txId);

    constructor() {
        owner = msg.sender;
    }

    //只有合约所有者才可以调用
    modifier onlyOwner{
        require(msg.sender==owner,"not owner");
        _;
    }

    receive() external payable { }
    
    /**
        _to:合约地址
        _amont:金额
        funName:函数名称
        timestamp:时间
    */
    function queue(address _to, uint _amont,string calldata funName,uint timestamp) onlyOwner  public returns (bool)  {
        require(_to != address(0), "_to address cannot be address zero");
        require(timestamp != 0, "timestamp cannot be zero");

        //校验时间
        if(timestamp < block.timestamp + MIN_TIME || timestamp > block.timestamp + MAX_TIME) {
            revert TimeError(_to, _amont , funName ,timestamp,"time error");
        }
        bytes32 txId = getTxId(_to,_amont,funName,timestamp);
        if(queueMapping[txId]){
            revert AlreadyQueuedError(txId);
        }

        queueMapping[txId] = true;
        emit TransactionQueueing(_to,_amont , funName ,timestamp );
        return true;
    }


    function getTxId(address _to, uint _amont,string calldata funName,uint timestamp) internal pure returns (bytes32){
        return keccak256(
            abi.encode(_to,_amont ,timestamp ,funName)
        );
    }


/**
        _to:合约地址
        _amont:金额
        funName:函数名称
        timestamp:时间
        _data:函数的参数
    */
    function execute(address _to, uint _amont,string calldata funName,uint timestamp,bytes calldata _data) payable external onlyOwner returns (bool){
        require(_to != address(0), "_to address cannot be address zero");
        require(timestamp != 0, "timestamp cannot be zero");

        bytes32 txId = getTxId(_to,_amont,funName,timestamp);
        if (!queueMapping[txId]){
            revert QueuedTxNotExist(_to,_amont , funName ,timestamp);
        }
         //校验时间
        if(block.timestamp   < timestamp+ MIN_TIME || block.timestamp   >  timestamp+ MAX_TIME) {
            revert TimeError(_to, _amont , funName ,timestamp,"execute time error");
        }
        bytes memory data;
        if (bytes(funName).length > 0){
            data = abi.encodePacked(bytes4(keccak256(bytes(funName))),_data) ;
        }else{
            data = _data;
        }


        //调用函数，并返回值
        (bool success,bytes memory result) = _to.call{value:_amont}(_data);
        if (!success){
            revert CallFailError(txId);
        }
        //调用完毕
        queueMapping[txId] = false;
        emit TransactionExecuteSuccess(txId);
        return success;

    }

    function cancel(bytes32 _txId) external onlyOwner {
        if (!queueMapping[_txId]) revert CancelError(_txId);

        queueMapping[_txId] = false;
        emit CancelSuceess(_txId);
    }
}


contract TestTimeLock{
address public timeLock;

    constructor(address _timeLock){
        timeLock =_timeLock;
    }
        function test() external {
        require(msg.sender == timeLock);
        // more code such as
        // - 升级合约
        // - 转移资产
        // - 修改预⾔机
        }
        function getTimestamp() external view returns(uint){
            return block.timestamp + 100;
        }
}