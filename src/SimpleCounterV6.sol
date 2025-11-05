// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {RoleBasedAccess} from "./RoleBasedAccess.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/Test.sol";
contract SimpleCounterV6 is RoleBasedAccess {
    uint256 private number = 0;

    event Incremented(address indexed sender, uint256 from, uint256 to);
    event IncrementedBatch(address indexed sender, uint256 from, uint256 to);
    constructor() RoleBasedAccess() {}

    function increment() public payable onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        console.log("current gas : ", gasleft());
        emit Incremented(msg.sender, number, number + 1);
        number++;
        console.log("current gas after : ", gasleft());
    }

    function decrement() public onlyRole(RoleBasedAccess.PROFESSOR_ROLE) {
        number--;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function incrementBatch(
        uint256 t
    ) public payable onlyRole(RoleBasedAccess.STUDENT_ROLE) {
        emit Incremented(msg.sender, number, number + t);
        for (uint256 i = 0; i < t; i++) {
            increment();
        }
    }

    function withdraw(
        address _to,
        uint256 _amount
    ) public onlyRole(STUDENT_ROLE) {
        console.log("current gas : ", gasleft());
        (bool success, ) = _to.call{value: _amount}(""); // forwards all gas.
        console.log("current gas : ", gasleft());
        require(success, "Ether transfer failed");
    }

    function withdrawErc20(address _to, IERC20 _token, uint256 _amount) public {
        console.log("current `_to` Token Balance", _token.balanceOf(_to));
        console.log("counter contract balance of token", _token.balanceOf(address(this)));
        console.log("current balance of spender : ", _token.balanceOf(msg.sender));
        // the contract hold the tokens, msg.sender can spend it for the contract.
        console.log("current allowance of spender :", _token.allowance(address(this), msg.sender)); 

        // you can simply call
        _token.transfer(_to, _amount);
        // in this, transferFrom, the caller becomes the "counter" contract and it checks if "counter" contract have allowance to spend tokens from "counter" contract : ideally it "no" or not required.
        // _token.transferFrom(address(this), _to, _amount); 

        console.log("new `to` Token Balance", _token.balanceOf(_to));
        console.log("new contract balance of token", _token.balanceOf(address(this)));
        console.log("new balance of spender : ", _token.balanceOf(msg.sender));
        // the contract hold the tokens, msg.sender can spend it for the contract.
        console.log("new allowance of spender :", _token.allowance(address(this), msg.sender));
    }

    function approve(address _spender, IERC20 _token, uint256 _amount) public {
        // must get approval from the contract to spend its tokens.
        _token.approve(_spender, _amount);
    }
}
