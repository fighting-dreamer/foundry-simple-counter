// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
    Time controller actuall does the operation on behalf of the contract operators/owner
    it have proposers nad executors and admin
    say, an EOA or multi-sig or some contract deploy a contract the time-controller contract
    it must have some proposers and executors if admin not set or some admin if you want to change the proposers etc later.
    proposers can define what to be called and related info of calling
    executors can execute, some caveats are like executors can be set to address(0) => anyone can execute

    basic problem i feel is the loss of access control on the operation as now only time-controller contract(S) can operate on the relevant function.
    now, either we have other contrracts define or duplicate some defination of roles or we update the access to time-controller contract address.
    [TODO be experimented with ] : other approach is to enable access only at time of operation and stop afterwards like in same transaction.


    -----------

    here, i want to control the timelock on increment operation, i can define a min-delay then i defin the increment operation as "scheduled operation"
    `
*/

contract MyTimeController is TimelockController {

    constructor(
        address[] memory proposers,
        address[] memory executors
    ) TimelockController(10, proposers, executors, msg.sender) {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(TimelockController)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}