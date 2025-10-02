// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
contract RoleBasedAccess is AccessControl {
    bytes32 constant public STUDENT_ROLE = keccak256("STUDENT_ROLE");
    bytes32 constant public PROFESSOR_ROLE = keccak256("PROFESSOR_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function submitTest() public view returns (string memory) {
        require(hasRole(STUDENT_ROLE, msg.sender), "you are not a student");

        return "Test Submitted";
    }

    function gradeTest() public view returns (string memory) {
        require(hasRole(PROFESSOR_ROLE, msg.sender), "You are not a professor.");

        return "Test Graded";
    }
}