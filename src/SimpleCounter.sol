// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RoleBasedAccess} from "./RoleBasedAccess.sol";

contract SimpleCounterV3 is RoleBasedAccess {
    uint256 private number = 0;

    event Incremented(address indexed sender, uint256 from, uint256 to);
    event IncrementedBatch(address indexed sender, uint256 from, uint256 to);
    constructor() RoleBasedAccess() {}

    function increment() public onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        emit Incremented(msg.sender, number, number + 1);
        number++;
    }

    function decrement() public onlyRole(RoleBasedAccess.PROFESSOR_ROLE) {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function incrementBatch(
        uint256 t
    ) public onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        emit Incremented(msg.sender, number, number + t);
        for (uint256 i = 0; i < t; i++) {
            increment();
        }
    }
}
