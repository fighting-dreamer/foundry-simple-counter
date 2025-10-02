// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
contract SimpleCounter is AccessControl {
    bytes32 public constant SET_NUMBER_ROLE = keccak256("SET_NUMBER_ROLE");
    bytes32 public constant OPERATE_COUNTER = keccak256("OPERATE_COUNTER");

    modifier canSetNumber() {
        require(hasRole(SET_NUMBER_ROLE, msg.sender), "Require number setter role");
        _ ;
    }

    modifier canOperate() {
        require(hasRole(OPERATE_COUNTER, msg.sender), "Not permissioned");
        _ ;
    }

    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
