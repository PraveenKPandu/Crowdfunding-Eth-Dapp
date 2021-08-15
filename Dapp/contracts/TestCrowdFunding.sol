// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./CrowdFunding.sol";

contract TestCrowdFunding is CrowdFunding {
    uint time;
    
    constructor (
        string memory contractName,
        uint targetAmount,
        uint durationInMin,
        address payable beneficiaryAddress
    )
    CrowdFunding(contractName, targetAmount, durationInMin, beneficiaryAddress) public {

    }

    function currentTime() internal view returns(uint) {
        return time;
    }

    function setCurrentTime(uint newTime) public {
        time = newTime;
    }

}