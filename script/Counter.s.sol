// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SimpleCounter} from "../src/SimpleCounter.sol";

contract SimpleCounterScript is Script {
    SimpleCounter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new SimpleCounter();

        vm.stopBroadcast();
    }
}
