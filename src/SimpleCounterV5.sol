// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RoleBasedAccess} from "./RoleBasedAccess.sol";
import {console} from "forge-std/Test.sol";
contract SimpleCounterV5 is RoleBasedAccess {
    uint256 private number = 0;

    event Incremented(address indexed sender, uint256 from, uint256 to);
    event IncrementedBatch(address indexed sender, uint256 from, uint256 to);
    constructor() RoleBasedAccess() {}

    function increment() public payable onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        console.log("current gas : ", gasleft());
        emit Incremented(msg.sender, number, number + 1);
        number++;
        console.log("current gas after : ", gasleft());
    }

    function decrement() public onlyRole(RoleBasedAccess.PROFESSOR_ROLE) {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function incrementBatch(
        uint256 t
    ) public payable onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        emit Incremented(msg.sender, number, number + t);
        for (uint256 i = 0; i < t; i++) {
            increment();
        }
    }

    function withdraw(
        address _to,
        uint256 _amount
    ) public onlyRole(STUDENT_ROLE) {
        console.log("current gas : ", gasleft());
        (bool success, ) = _to.call{value: _amount}(""); // forwards all gas.
        console.log("current gas : ", gasleft());
        require(success, "Ether transfer failed");
    }
}
