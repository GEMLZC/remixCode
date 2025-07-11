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
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
        //已筹集的资金
        uint pledged;
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
    event Donate(uint _no,address addr,uint amount);
    event BackDonate(uint _no,uint amount,address addr);
    event Refund(uint _no,uint amount,address addr);

    constructor(address _token) {
       token = IERC20(_token);
       founder = msg.sender;
    }

    //发起众筹（发起者）
    function createCrowdFund(uint256 target, uint32  _startTime,uint32 second) external {
        require(_startTime > block.timestamp, "create crowdfund time error");
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
            endStatus:false,
            pledged:0
            }
        );
       emit CreateCrowdFund(msg.sender,_startTime,_endTime,target,no);      
    }

    //取消众筹（发起者）
    function cancel(uint _no) external{
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
        require(founder == msg.sender, "only founder cancel");
        require(crowdInfo.startStatus, "crowd end");
        require(block.timestamp < crowdInfo.startTime && block.timestamp <= crowdInfo.endTime 
        , "only start time cancel");
        crowdInfo.startStatus = false;
        crowdInfo.endStatus = true;
        delete crowdInfoNum[_no];
        emit Cancel(_no);
    }


    //认捐资⾦（⽀持者）
    function donate(uint _no,uint amount) external {
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
         require(crowdInfo.startStatus, "crowd end");
         require(block.timestamp >= crowdInfo.startTime && block.timestamp <= crowdInfo.endTime 
        , "donate time error");
        require(amount > 0 , "donate value must ge 0");

        crowdInfo.pledged += amount;
        countAddrAmount[crowdInfo.roundNumber][msg.sender] += amount;
        token.transferFrom(msg.sender,address(this),amount);
        emit Donate(_no,msg.sender,amount);
    }


    //提取资⾦（发起者）  注意判断提取资金的时机是与失败退款的判断逻辑是相反的，资金池达到目标资金才可以提取；失败退款只能未达到目标资金才能提取
    function withdraw(uint _no) external {
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
        require(founder == msg.sender, "only founder withdraw");
        require(block.timestamp > crowdInfo.endTime , "end time error ");
        require(crowdInfo.pledged >= crowdInfo.targetFund, "pledged < goal");
        uint _amount = crowdInfo.pledged;
        crowdInfo.pledged -= _amount;
        token.transfer(founder, _amount);
        emit Withdraw(_no,_amount);
    }
        
    //撤回认捐（⽀持者）
    function backDonate(uint _no,uint amount) external{
        CrowdInfo storage crowdInfo = crowdInfoNum[_no];
         require(block.timestamp <= crowdInfo.endTime, "ended");
         crowdInfo.pledged -= amount;
         countAddrAmount[_no][msg.sender] -= amount;
         token.transfer(msg.sender, amount);
         emit BackDonate(_no,amount,msg.sender);
    }
   

    //失败退款（⽀持者）  此处没有扣减资金池余额因为活动已结束，需要保存历史记录，并且是在资金池没有达到目标资金时调用的
    function refund(uint _no) external {
         CrowdInfo storage crowdInfo = crowdInfoNum[_no];
         require(block.timestamp > crowdInfo.endTime, "not ended");
         
         require(crowdInfo.pledged < crowdInfo.targetFund, "pledged >= goal");
         uint amount = countAddrAmount[_no][msg.sender]; 
         countAddrAmount[_no][msg.sender] = 0;
         token.transfer(msg.sender, amount);
         emit Refund(_no,amount,msg.sender);
    }
}
