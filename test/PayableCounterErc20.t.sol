// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {SimpleCounterV6} from "../src/SimpleCounterV6.sol";
import {LIT_ERC20Token} from "../src/token/MyERC20.sol";

pragma solidity ^0.8.26;

contract PayableCounterErc20 is Test {
    SimpleCounterV6 counter;
    address student;
    LIT_ERC20Token myToken;
    address testAddr;

    function setUp() public {
        counter = new SimpleCounterV6();
        student = makeAddr("student");
        vm.prank(student);
        myToken = new LIT_ERC20Token();
        testAddr = makeAddr("test");

        counter.grantRole(counter.STUDENT_ROLE(), student);
    }

    // student hold the erc-20 tokens, counter contract does not, so can;t withdraw and send to test addr.
    function test_Revert_withdraw_erc20() public {
        vm.prank(student);
        vm.expectRevert();
        counter.withdrawErc20(testAddr, myToken, 1);
    }

    // counter contract got the balance, but student cant spend it for counter ie not approved.
    function test_Revert_withdraw_erc20_2() public {
        vm.startPrank(student);
        myToken.transfer(address(counter), 10);
        vm.expectRevert();
        counter.withdrawErc20(testAddr, myToken, 2);
        vm.stopPrank();
    }

    function test_withdraw_erc20_3() public {
        vm.startPrank(student);
        myToken.transfer(address(counter), 10);
        // counter.approve(student, myToken, 5); // now approved to spend on counter contract's behalf.
        counter.withdrawErc20(testAddr, myToken, 2);
        vm.stopPrank();
        assertEq(myToken.balanceOf(testAddr), 2);
    }

    // function test_Revert_withdraw_more_than_held() public {
    //     vm.deal(address(counter), 0.5 ether);
    //     address testAddr = makeAddr("test");

    //     vm.prank(student);
    //     vm.expectRevert();
    //     counter.withdraw(testAddr, 1 ether);

    //     assertEq(testAddr.balance, 1 ether);
    //     console.log("test addr balance : ", testAddr.balance);
    // }
}
