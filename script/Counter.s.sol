// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SimpleCounter} from "../src/SimpleCounter.sol";

contract SimpleCounterScript is Script {
    SimpleCounter public counter;

    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("WALLET_PRIVATE_KEY");
        address addr = vm.addr(privateKey);
        console.log("address", addr);
        vm.startBroadcast(privateKey);
        counter = new SimpleCounter();
        vm.stopBroadcast();
    }
}
