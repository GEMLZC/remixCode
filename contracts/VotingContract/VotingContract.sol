// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "@openzeppelin/contracts/utils/Counters.sol"; 
import "hardhat/console.sol";

contract VotingContract {
    using Counters for Counters.Counter;

    //投票者id计数器
    Counters.Counter public _voterId;
    //候选人id计数器
    Counters.Counter public _candidateId;

    //投票组织者
    address public immutable votingOrganizer;

    //候选人
    struct Candidate{
        uint256 id;
        string ipfs;
        address candidateAddr; //候选人地址
        uint256 voteCount; //票数
        string age;          // 年龄（应为uint）
        string name;         // 姓名
        string image;        // 图片URL/哈希
    }

    //所有候选人数组
    address[] public candidateArray;
    //候选人地址映射
    mapping(address => Candidate) candidateMapping;


    //投票者
    struct Voter{
        uint256 id;  //投票者id
        uint256 candidateId;   //候选人id
        string ipfs;
        address voterAddr; //投票者地址
        bool voter_allowed; //是否授权
        bool voter_voted;  //是否已投票
        string age;          // 年龄（应为uint）
        string name;         // 姓名
        string image;        // 图片URL/哈希
    }


    //所有投票者数组
    address[] public voterArray;
    //投票者地址映射
    mapping(address => Voter) voterMapping;
    //已经投票的人
    address[] public voteredArray;
     //已经投票的人地址映射
    mapping(address => Voter) voteredMapping;

    event CandidateCreate(
        uint256 indexed candidateId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string ipfs
    );




     event VoterCreated(
        uint256 indexed voter_voterId,
        string voter_name,
        string voter_image,
        address voter_address,
        bool voter_allowed,
        bool voter_voted,
        string voter_ipfs
    );


    constructor() {
        votingOrganizer = msg.sender;
    }


    modifier organizer(){
        require(votingOrganizer == msg.sender, "You have no azuthorization ");
        _;
    }

    //设置候选人
    function setCandidate(
        address _candidateAddress, 
        string memory ipfs,
        string memory age,
        string memory name,
        string memory image  
    ) external organizer{
        require(_candidateAddress != address(0), "candidateAddress error");
        Candidate storage candidate = candidateMapping[_candidateAddress];
        _candidateId.increment();
        uint256 _id = _candidateId.current();
        candidate.id = _id;
        candidate.age = age;
        candidate.candidateAddr = _candidateAddress;
        candidate.image = image;
        candidate.ipfs = ipfs;
        candidate.name = name;

        candidateArray.push(_candidateAddress);
         emit CandidateCreate(
            candidate.id,
            age,
            name,
            image,
            candidate.voteCount,
            candidate.candidateAddr,
            candidate.ipfs
        );
    }

    //给用户授权投票
    function voterRight(
        string memory ipfs,
        address voterAddr,
        string memory age,
        string memory name,
        string memory image ) external organizer{
        require(voterAddr != address(0), "userAddr error");
        Voter storage voter = voterMapping[voterAddr];
        require(!voter.voter_voted, "");
        _voterId.increment();
        uint256 _id = _voterId.current();
        voter.id = _id;
        voter.age = age;
        voter.image = image;
        voter.ipfs = ipfs;
        voter.name = name;
        voter.voter_allowed = true;
        voter.voter_voted = false;
        voter.voterAddr = voterAddr;
        voterArray.push(voterAddr);
        emit VoterCreated(
            voter.id,
            name,
            image,
            voterAddr,
            voter.voter_allowed,
            voter.voter_voted,
            voter.ipfs
        );
    }

    //投票
    function vote(address _candidateAddress, uint256 _candidateVoteId) external {
        Voter storage voter = voterMapping[msg.sender];
        Candidate storage candidate = candidateMapping[_candidateAddress];
        require(candidate.id > 0);
        require(voter.id > 0);
        require(voter.voter_allowed);
        require(!voter.voter_voted);
        voter.voter_allowed = false;
        voter.candidateId = _candidateVoteId;
        voter.voter_voted = true;
        ++candidate.voteCount;
        voteredArray.push(msg.sender);
        voteredMapping[msg.sender] = voter;
    }


    
}