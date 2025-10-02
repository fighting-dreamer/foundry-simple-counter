// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleCounterV1 {
    uint256 private number = 0;

    function increment() public {
        number++;
    }

    function decrement() public {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
