// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract SimpleCounter is AccessControl {
    // =============================================================
    // Events
    // =============================================================

    event NumberSet(uint256 indexed newNumber, address indexed setter);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    // =============================================================
    // State Variables
    // =============================================================

    /**
     * @notice Role for addresses that can set the number directly.
     */
    bytes32 public constant SET_NUMBER_ROLE = keccak256("SET_NUMBER_ROLE");

    /**
     * @notice Role for addresses that can increment/decrement the counter.
     */
    bytes32 public constant OPERATE_COUNTER = keccak256("OPERATE_COUNTER");

    uint256 public number; // The current value of the counter.

    // =============================================================
    // Modifiers
    // =============================================================

    /// @dev Ensures the caller has the SET_NUMBER_ROLE.
    modifier canSetNumber() {
        require(hasRole(SET_NUMBER_ROLE, msg.sender), "SimpleCounter: Caller is not a number setter");
        _;
    }

    /// @dev Ensures the caller has the OPERATE_COUNTER role.
    modifier canOperate() {
        require(hasRole(OPERATE_COUNTER, msg.sender), "SimpleCounter: Caller cannot operate counter");
        _;
    }

    constructor() {
        // The deployer of the contract is granted the default admin role.
        // This role is required to grant other roles.
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // =============================================================
    // External Functions
    // =============================================================

    function setNumber(uint256 newNumber) public canSetNumber {
        number = newNumber;
        emit NumberSet(newNumber, msg.sender);
    }

    /**
     * @notice Increments the counter by 1.
     * @dev Can only be called by an address with the OPERATE_COUNTER role. Emits a {NumberSet} event.
     */
    function increment() public canOperate {
        number++;
        emit NumberSet(number, msg.sender);
    }

    /**
     * @notice Grants a role to an account. Emits a {RoleGranted} event.
     * @dev Can only be called by an address with the DEFAULT_ADMIN_ROLE.
     * @param role The role to grant.
     * @param account The address to grant the role to.
     */
    function grantRole(bytes32 role, address account) public override {
        super.grantRole(role, account);
        emit RoleGranted(role, account, msg.sender);
    }
}
