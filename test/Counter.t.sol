// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleCounterV1} from "../src/SimpleCounter.sol";

contract SimpleCounterTest is Test {
    SimpleCounterV1 public counter;

    function setUp() public {
        counter = new SimpleCounterV1();
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.getNumber(), 1);
    }
}
