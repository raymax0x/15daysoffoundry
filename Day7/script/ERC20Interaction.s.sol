//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Mintable} from "../src/ERC20Mintable.sol";

contract ERC20Interaction is Script {
    function run() external {
        uint256 userPrivateKey = vm.envUint("Private_Key");
        address erc20Addr = vm.envAddress("Contract_Address");

        vm.startBroadcast(userPrivateKey);

        ERC20Mintable erc20Token = ERC20Mintable(erc20Addr);

        console.log("erc20Token name", erc20Token.name());
        console.log("erc20Token name", erc20Token.symbol());\
        vm.stopBroadcast();
    }
}
