// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleShop} from "../src/SimpleShop.sol";

// contract SimpleShopTest is Test {
//     struct Item {
//         string name;
//         uint256 price;
//         uint256 quantity;
//         bool available;
//     }

//     SimpleShop public shop;

//     address public owner = address(0x1);
//     address public user1 = address(0x2);
//     address public user2 = address(0x3);
//     address public user3 = address(0x4);

//     function setUp() public {
//         vm.prank(owner);
//         shop = new SimpleShop();

//         vm.deal(user1, 10 ether);
//         vm.deal(user2, 10 ether);
//         vm.deal(user3, 10 ether);
//     }

//     function test_gas_addItem() public {
//         vm.prank(owner);

//         uint256 gasBefore = gasleft();
//         console.log("gasBefore", gasBefore);
//         shop.addItem("Apple ", 1 ether, 100);

//         uint256 gasUsed = gasBefore - gasleft();
//         console.log("gas used for addItem", gasUsed);
//     }

//     function test_gas_multiplePurchase() public {
//         vm.prank(owner);
//         shop.addItem("Apple ", 1 ether, 100);

//         vm.prank(user1);
//         uint256 gasBefore = gasleft();
//         shop.purchaseItem{value: 1 ether}(0, 1);

//         uint256 firstPurchaseGas = gasBefore - gasleft();
//         console.log("firstPurchaseGas", firstPurchaseGas);

//         vm.prank(user2);
//         gasBefore = gasleft();
//         shop.purchaseItem{value: 1 ether}(0, 1);

//         uint256 secondPurchaseGas = gasBefore - gasleft();
//         console.log("secondPurchaseGas", secondPurchaseGas);
//     }
// }
