// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RoleBasedAccess} from "./RoleBasedAccess.sol";

contract SimpleCounterV3 is RoleBasedAccess {
    uint256 private number = 0;
    constructor() RoleBasedAccess() {}

    function increment() public onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        number++;
    }

    function decrement() public onlyRole(RoleBasedAccess.PROFESSOR_ROLE) {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}

// contract SomeContract {
//     uint256 private number;

//     function somefunc() public view returns(uint256) {
//         return number;
//     }
// }