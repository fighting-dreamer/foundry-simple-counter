// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {SimpleCounterV2} from "../src/SimpleCounter.sol";

pragma solidity ^0.8.26;

contract SimpleCounterTest is Test {
    SimpleCounterV2 public counter;    

    function setUp() public {}

    function test_Ownership() public {
        counter = new SimpleCounterV2();
        address other = makeAddr("other");

        vm.prank(other);
        vm.expectRevert();
        counter.increment();
    }

}
