// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFunding {
    enum State { Ongoing, Failed, Succeeded, PaidOut }


    string public name;
    uint public targetAmount;
    uint public deadline;
    address payable public beneficiary;
    address public owner;
    uint public totalCollected;
    mapping(address => uint) public amounts;
    bool public collected; 
    State public state;


    modifier inState(State expectedState) {
        require(state == expectedState, "Invalid State");
        _;
    }

    constructor(
        string memory contractName,
        uint targetAmountEth,
        uint durationInMin,
        address payable beneficiaryAddress
    )
        public
    {
        name = contractName;
        targetAmount = Utils.etherToWei(targetAmountEth);
        fundingDeadline = currentTime() + Utils.minsToSecs(durationInMin);
        beneficiary = beneficiaryAddress;
        owner = msg.sender;
        state = State.Ongoing;
    }


    function contribute() public payable inState(State.Ongoing){
        require(beforeDeadline(), "Deadline passed. Cannot contribute");
        amounts[msg.sender] += msg.value;
        totalCollected += msg.value;

        if (totalCollected >= targetAmount) {
            collected = true;
        }
    }

    function collect() public inState(State.Succeeded) {
        if (beneficiary.send(totalCollected)) {
            state = State.PaidOut;
        } else {
            state = State.Failed;
        }
    }

    function withdraw() public inState(State.Failed) {
        require (amounts[msg.sender] > 0, "Nothing was Contributed");
        uint contributed = amounts[msg.sender];
        amounts[msg.sender] = 0;

    }

    function beforeDeadline() public view returns(bool) {
        return currentTime() < deadlines;
    }

    function currentTime() internal view returns(uint) {
        return now;
    }


}