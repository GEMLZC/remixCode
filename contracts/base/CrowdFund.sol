// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
众筹 是⼀种资⾦募集的⽅式，发起者通过某个公开平台向⼤众募集资⾦，⽬标是⽤这些资⾦
启动或推动某个项⽬、产品或社会事业。随着Web3技术的兴起，智能合约去中⼼化的⽅式的
使得众筹活动更加公正和⾼效，资⾦流动更加安全与透明。


实现⼀个众筹平台合约：
⻆⾊
    发起者
    ⽀持者
功能
    发起众筹（发起者）
    取消众筹（发起者）
    认捐资⾦（⽀持者）
    撤回认捐（⽀持者）
    提取资⾦（发起者）
    失败退款（⽀持者）

*/

interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}

//多轮众筹
contract CrowdFund {
    //接口地址
    IERC20 public immutable token;
    //众筹的相关信息
    struct CrowdInfo{
        //开始时间
        uint32  startTime;
        //结束时间
        uint32  endTime;
        //目标资金
        uint targetFund;
        //第几轮众筹
        uint  roundNumber;
        //是否开始
        bool startStatus;
        //是否结束
        bool endStatus;
    
    }

    
    //记录第几轮下的每个人员募捐了多少
    mapping(uint => mapping(address => uint)) public  countAddrAmount;
    //记录是第几轮众筹
    mapping(uint => CrowdInfo) public crowdInfoNum;
    //发起者地址
    address public founder;
    //已经发起到第几轮众筹
    uint public no;

    event CreateCrowdFund(address founder, uint32 _startTime,uint32 _endTime,uint target,uint no); 
    event Cancel(uint no);
    event Withdraw(uint no,uint amount);

    constructor(address _token) {
       token = IERC20(_token);
       founder = msg.sender;
    }

    //发起众筹（发起者）
    function createCrowdFund(uint256 target, uint32  _startTime,uint32 second) external {
        require(_startTime > block.timestamp +20, "create crowdfund time error");
        require(target > 0, " amount must ge 0");
        uint32 _endTime = uint32(block.timestamp + second);
        require(_endTime  > block.timestamp, " second error");
        require(founder == msg.sender, "only founder create");
        no++;
        crowdInfoNum[no]= CrowdInfo({
            startTime:_startTime,
            endTime:_endTime,
            targetFund:target,
            roundNumber:no,
            startStatus:true,
            endStatus:false
            }
        );
       emit CreateCrowdFund(msg.sender,_startTime,_endTime,target,no);      
    }

    //取消众筹（发起者）
    function cancel(uint _no) external{
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
        require(founder == msg.sender, "only founder cancel");
        require(crowdInfo.startStatus, "crowd end");
        require(block.timestamp >= crowdInfo.startTime && block.timestamp <= crowdInfo.endTime 
        , "only start time cancel");
        crowdInfo.startStatus = false;
        crowdInfo.endStatus = true;
        emit Cancel(_no);
    }


    //认捐资⾦（⽀持者）
    function donate(uint _no,uint amount) external {
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
         require(crowdInfo.startStatus, "crowd end");
         require(block.timestamp >= crowdInfo.startTime && block.timestamp <= crowdInfo.endTime 
        , "donate time error");
        require(amount > 0 , "donate value must ge 0");

        crowdInfo.targetFund += amount;
        countAddrAmount[crowdInfo.roundNumber][msg.sender] += amount;
        emit donate(_no,msg.sender,amount);
    }
        
    //撤回认捐（⽀持者）
   
    //失败退款（⽀持者）


    //提取资⾦（发起者）
    function withdraw(uint _no,uint amount) external {
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
        require(founder == msg.sender, "only founder withdraw");
        require(block.timestamp > crowdInfo.endTime , "end time error ");
        uint _amount = crowdInfo.targetFund;
        require(_amount >= amount, "not enough funds error ");
        crowdInfo.targetFund -= amount;
        token.transfer(founder, amount);
        emit Withdraw(_no,amount);
    }

}

