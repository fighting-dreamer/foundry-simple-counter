// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {SimpleCounterV2} from "../src/SimpleCounter.sol";

contract SimpleCounterScript is Script {
    SimpleCounterV2 public counter;

    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("WALLET_PRIVATE_KEY");
        address addr = vm.addr(privateKey);
        console.log("address", addr);
        console.log("Chain ID:", block.chainid);
        vm.startBroadcast(privateKey);
        counter = new SimpleCounterV2();
        vm.stopBroadcast();
    }
}
