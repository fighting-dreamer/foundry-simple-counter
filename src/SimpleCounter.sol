// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
contract SimpleCounterV2 is Ownable {
    uint256 private number = 0;
    constructor() Ownable(msg.sender) {}

    function increment() public onlyOwner {
        number++;
    }

    function decrement() public onlyOwner {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}

contract SomeContract {
    uint256 private number;

    function somefunc() public view returns(uint256) {
        return number;
    }
}