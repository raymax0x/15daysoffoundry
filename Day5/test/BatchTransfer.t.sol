// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {BatchTransfer} from "../src/BatchTransfer.sol";

contract BatchTransferTest is Test {
    BatchTransfer public bt;

    function setUp() public {
        bt = new BatchTransfer();
    }

    function test_BatchTransfer() public {
        address sender = makeAddr("sender");
        address recipient1 = makeAddr("r1");
        address recipient2 = makeAddr("r2");
        address recipient3 = makeAddr("r3");

        vm.deal(sender, 10 ether);

        address[] memory recipients = new address[](3);
        uint256[] memory amounts = new uint256[](3);

        recipients[0] = recipient1;
        recipients[1] = recipient2;
        recipients[2] = recipient3;

        amounts[0] = 2 ether;
        amounts[1] = 2 ether;
        amounts[2] = 1 ether;
        uint256 gasBefore = gasleft();
        console.log("gasBefore", gasBefore);
        vm.prank(sender);
        bt.batchTransfer{value: 5 ether}(recipients, amounts);

        uint256 gasUsed = gasBefore - gasleft();
        console.log("gas used for batchTransfer", gasUsed);

        assertEq(recipient1.balance, 2 ether);
        assertEq(recipient2.balance, 2 ether);
        assertEq(recipient3.balance, 1 ether);
        assertEq(sender.balance, 5 ether);
    }
}
