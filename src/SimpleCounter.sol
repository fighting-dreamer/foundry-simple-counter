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
    constructor() {
        // the "grantRole" expects if the caller of the func have the role who can alter or set another address for the given role.
        // since, default-admin is its own "admin role"
        // "grantRole" and "_grantRole" are differnt 
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); 
    }

    function setNumber(uint256 newNumber) public canSetNumber {
        number = newNumber;
    }

    function increment() public canOperate {
        number++;
    }
}
