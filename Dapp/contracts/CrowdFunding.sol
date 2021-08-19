// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Utils.sol"; 

contract CrowdFunding {
    using Utils for *;

    enum State { Ongoing, Failed, Succeeded, PaidOut }

    event CampaignFinished(
        address addr,
        uint totalCollected,
        bool succeeded
    );

    string public accountName;
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
    ) public
    {
        accountName = contractName;
        targetAmount = Utils.etherToWei(targetAmountEth);
        deadline = currentTime() + Utils.minsToSecs(durationInMin);
        beneficiary = beneficiaryAddress;
        owner = msg.sender;
        state = State.Ongoing;
    }


    function contribute() payable public inState(State.Ongoing){
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

        address payable addr1 = address(uint160(owner));

        if (!addr1.send(contributed)) {
            amounts[msg.sender] = contributed;
        }
    }

    function finishCrowdFunding() public inState(State.Ongoing) {
        require(!beforeDeadline(), "Cannot finish campaign before a deadline");

        if (!collected) {
            state = State.Failed;
        } else {
            state = State.Succeeded;
        }

        emit CampaignFinished(address(this), totalCollected, collected);
    }

    function beforeDeadline() public view returns(bool) {
        return currentTime() < deadline;
    }

    function currentTime() internal view returns(uint) {
        return block.timestamp;
    }

    function getTotalCollected() public view returns(uint) {
        return totalCollected;
    }

    function inProgress() public view returns (bool) {
        return state == State.Ongoing || state == State.Succeeded;
    }

    function isSuccessful() public view returns (bool) {
        return state == State.PaidOut;
    }

}