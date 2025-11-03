// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleCounterV2} from "../src/SimpleCounter.sol";

contract SimpleCounterTest is Test {
    SimpleCounterV2 public counter;

    function setUp() public {}

    function test_Ownership() public {
        counter = new SimpleCounterV2();
        console.log(address(counter));
        counter.increment();

        address otherUser = makeAddr("otherAccount");
        
        vm.expectRevert();
        vm.prank(otherUser);
        counter.increment();
    }

    function test_Increment() public {
        counter = new SimpleCounterV2();
        console.log(address(counter));
        counter.increment();
        uint256 newNumber = counter.getNumber();
        console.log("New number is:", newNumber);
        assertEq(newNumber, 1);
    }
}
