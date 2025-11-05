// SPDX-License-Identifier: MIT

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.26;

contract LIT_ERC20Token is ERC20 {
    constructor() ERC20("lit token", "lt") {
        _mint(msg.sender, 1000);
    }
}
