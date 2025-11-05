// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {SimpleCounterV3} from "../src/SimpleCounter.sol";

pragma solidity ^0.8.26;

contract ConunterWithTimelock is Test {
    uint256 public minDelay;
    address public proposer1;
    address public proposer2;
    address public executor;
    address public admin;

    SimpleCounterV3 public counter;
    TimelockController public timelocker;

    function setUp() public {
        minDelay = 10;
        proposer1 = makeAddr("proposer1");
        proposer2 = makeAddr("proposer2");
        executor = makeAddr("executor");
        admin = makeAddr("admin");

        counter = new SimpleCounterV3();

        // To fix the type error, we explicitly create dynamic memory arrays.
        // The literal `[proposer1, proposer2]` creates a fixed-size array `address[2]`,
        // but the constructor expects a dynamic array `address[]`.
        address[] memory proposers = new address[](2);
        proposers[0] = proposer1;
        proposers[1] = proposer2;

        address[] memory executors = new address[](1);
        executors[0] = executor;

        timelocker = new TimelockController(
            minDelay,
            proposers,
            executors,
            admin
        );
    }

    function test_IncrementBatch_delay_less_minDelay() public {
        uint256 t = 5;
        uint256 delta = 2;
        vm.prank(proposer1);
        vm.expectRevert(
            abi.encodeWithSelector(
                TimelockController.TimelockInsufficientDelay.selector,
                minDelay - delta,
                minDelay
            )
        );
        timelocker.schedule(
            address(counter),
            0,
            abi.encode(t),
            "",
            "",
            minDelay - delta
        );
    }

    function test_Revert_IncrementBatch_before_minDelay() public {
        uint256 t = 5;
        uint256 delta = 2;
        // schedule the operation
        vm.prank(proposer1);
        timelocker.schedule(
            address(counter),
            0,
            abi.encode(t),
            "",
            "",
            minDelay
        );

        // try to execute before scheduled time : should fail
        vm.warp(block.timestamp + minDelay - delta);
        vm.prank(executor);
        vm.expectPartialRevert(TimelockController.TimelockUnexpectedOperationState.selector);
        timelocker.execute(address(counter), 0, abi.encode(t), "", "");
    }

    function test_Revert_Increment_after_mindelay_and_not_authorized() public {
        uint256 t = 5;
        bytes memory operationData = abi.encodeWithSelector(SimpleCounterV3.incrementBatch.selector, t);
        // uint256 delta = 2;
        // schedule the operation
        vm.prank(proposer1);
        timelocker.schedule(
            address(counter),
            0,
            operationData,
            "",
            "",
            minDelay
        );

        // try to execute before scheduled time : should fail
        vm.warp(block.timestamp + minDelay);
        counter.grantRole(counter.STUDENT_ROLE(), executor);// executor have the role, but timelocker does not => fails as timelocker must have the authorization.
        vm.prank(executor); 
        vm.expectPartialRevert(IAccessControl.AccessControlUnauthorizedAccount.selector);
        timelocker.execute(address(counter), 0, operationData, "", "");
    }

    function test_Increment_success_After_minDelay_and_authorized() public {
        uint256 t = 5;
        bytes memory operationData = abi.encodeWithSelector(SimpleCounterV3.incrementBatch.selector, t);
        // uint256 delta = 2;
        // schedule the operation
        vm.prank(proposer1);
        timelocker.schedule(
            address(counter),
            0,
            operationData,
            "",
            "",
            minDelay
        );

        // try to execute before scheduled time : should fail
        vm.warp(block.timestamp + minDelay);
        // timelocker have the "student" role, but executor does not => success as timelocker must have the authorization, not required for executor to be having certain role on end target contract.
        counter.grantRole(counter.STUDENT_ROLE(), address(timelocker));
        vm.prank(executor); 
        timelocker.execute(address(counter), 0, operationData, "", "");
    }
}
