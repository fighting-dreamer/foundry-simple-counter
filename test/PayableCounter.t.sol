// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {SimpleCounterV5} from "../src/SimpleCounterV5.sol";

pragma solidity ^0.8.26;

contract PayableCounter is Test {
    SimpleCounterV5 counter;
    address student;
    function setUp() public {
        counter = new SimpleCounterV5();
        student = makeAddr("student");
        counter.grantRole(counter.STUDENT_ROLE(), student);
    }

    function test_paying_to_increment_function() public {
        vm.prank(student);
        vm.deal(student, 10 ether);
        uint256 balance = address(counter).balance;
        console.log("counter balance ", address(counter).balance);
        counter.increment{value:1 ether}();
        uint256 afterCallBalance = address(counter).balance;
        console.log("counter balance ", address(counter).balance);
        assertEq(balance + 1 ether, afterCallBalance);
    }

    function test_withdraw() public {
        vm.deal(address(counter), 10 ether);
        address testAddr = makeAddr("test");
        
        vm.prank(student);
        counter.withdraw(testAddr, 1 ether);

        assertEq(testAddr.balance, 1 ether);
        console.log("test addr balance : ", testAddr.balance);
    }

    function test_Revert_withdraw_more_than_held() public {
        vm.deal(address(counter), 0.5 ether);
        address testAddr = makeAddr("test");
        
        vm.prank(student);
        vm.expectRevert();
        counter.withdraw(testAddr, 1 ether);

        assertEq(testAddr.balance, 1 ether);
        console.log("test addr balance : ", testAddr.balance);
    } 
}