// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFunding {
    enum Status { Ongoing, Failed, Succeeded, PaidOut }


    string public projectName;
    uint public targetAmount;
    uint public deadline;
    address payable public beneficiary;
    address public owner;
    uint public totalCollected;

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
        fundingDeadline = currentTime() + Utils.minutesToSeconds(durationInMin);
        beneficiary = beneficiaryAddress;
        owner = msg.sender;
        state = State.Ongoing;
    }


    function contribute() public payable inState(State.Ongoing){

    }

    function collect() public inState(State.Succeeded) {

    }

    function withdraw() public inState(State.Failed) {

    }

    
