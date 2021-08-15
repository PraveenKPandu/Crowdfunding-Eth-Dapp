// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library Utils {
    function etherToWei(uint ethSum) public pure returns(uint) {
        return ethSum * 1 ether;
    }

    function minsToSecs(uint timeInMins) public pure returns(uint) {
        return timeInMins * 1 minutes;
    }
}