//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Mintable} from "../src/ERC20Mintable.sol";

contract DeployErc20Token is Script {
    function run() external {
        vm.startBroadcast();
        ERC20Mintable erc20token = new ERC20Mintable();
        console.log("contract address deployed to:", address(erc20token));
        console.log("token name", erc20token.name());
        vm.stopBroadcast();
    }
}
