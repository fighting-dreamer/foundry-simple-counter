// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleCounterV3} from "../src/SimpleCounter.sol";

contract SimpleCounterTest is Test {
    SimpleCounterV3 public counter;
    address public professor;
    address public student1;
    address public student2;
    address public admin;

    constructor() {
        admin = makeAddr("admin");
        student1 = makeAddr("student1");
        student2 = makeAddr("student2");
        professor = makeAddr("professor");
    }

    function setUp() public {
        // starting prank
        vm.startPrank(admin);
        // create the contract
        counter = new SimpleCounterV3();
        // giving student role to some addresses
        // you can't use RoleBasedAccess.STUDENT_ROLE or RoleBasedAccess.PROFESSOR_ROLE
        // also, note that, you have made a function call using parenthesis, its "STUDENT_ROLE()", not just "STUDENT_ROLE"
        counter.grantRole(counter.STUDENT_ROLE(), student1); 
        counter.grantRole(counter.STUDENT_ROLE(), student2);
        // giving professor role to some addresses
        counter.grantRole(counter.PROFESSOR_ROLE(), professor);
        // stopping prank
        vm.stopPrank();
    }

    function test_increment() public {
        console.log(counter.getNumber());
        vm.prank(student1);
        counter.increment();
        uint got = counter.getNumber();
        console.log(got);
        uint expected = 1;
        assertEq(expected, got);
    }

    // function test_Increment() public {
    //     counter = new SimpleCounterV2();
    //     console.log(address(counter));
    //     counter.increment();
    //     uint256 newNumber = counter.getNumber();
    //     console.log("New number is:", newNumber);
    //     assertEq(newNumber, 1);
    // }
}
