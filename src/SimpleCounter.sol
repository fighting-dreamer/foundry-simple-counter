// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RoleBasedAccess} from "./RoleBasedAccess.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract SimpleCounterV4 is RoleBasedAccess, TimelockController {
    uint256 private number = 0;
    constructor() RoleBasedAccess() TimelockController(10, new address[](0), new address[](0), msg.sender) {}

    function increment() public onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        number++;
    }

    function decrement() public onlyRole(RoleBasedAccess.PROFESSOR_ROLE) {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(TimelockController,AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}