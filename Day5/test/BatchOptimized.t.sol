// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/BatchOptimized.sol";

contract BatchOptimizedTest is Test {
    BatchOptimized public bt;

    address sender;
    address r1;
    address r2;
    address r3;

    function setUp() public {
        bt = new BatchOptimized();

        sender = makeAddr("sender");
        r1 = makeAddr("r1");
        r2 = makeAddr("r2");
        r3 = makeAddr("r3");

        vm.deal(sender, 10 ether); // fund sender
    }

    function test_BatchTransfer_Works() public {
        address[] memory recipients = new address[](3);
        recipients[0] = r1;
        recipients[1] = r2;
        recipients[2] = r3;

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 2 ether;
        amounts[1] = 2 ether;
        amounts[2] = 1 ether;

        vm.prank(sender);
        bt.batchTransfer{value: 5 ether}(recipients, amounts);

        assertEq(r1.balance, 2 ether);
        assertEq(r2.balance, 2 ether);
        assertEq(r3.balance, 1 ether);
        assertEq(sender.balance, 5 ether); // leftover since 10 - 5 = 5
    }

    // function test_RevertIf_LengthMismatch() public {
    //     address[] memory recipients = new address[](2);
    //     recipients[0] = r1;
    //     recipients[1] = r2;

    //     uint256[] memory amounts = new uint256[](3);
    //     amounts[0] = 1 ether;
    //     amounts[1] = 1 ether;
    //     amounts[2] = 1 ether;

    //     vm.prank(sender);
    //     vm.expectRevert("Length mismatch");
    //     bt.batchTransfer{value: 3 ether}(recipients, amounts);
    // }

    // function test_RevertIf_IncorrectValueSent() public {
    //     address[] memory recipients = new address[](2);
    //     recipients[0] = r1;
    //     recipients[1] = r2;

    //     uint256[] memory amounts = new uint256[](2);
    //     amounts[0] = 1 ether;
    //     amounts[1] = 2 ether;

    //     vm.prank(sender);
    //     vm.expectRevert("Incorrect ETH sent");
    //     bt.batchTransfer{value: 2 ether}(recipients, amounts); // should be 3
    // }

    // /// @dev A simple test to show up in gas reports
    // function test_GasReport() public {
    //     address[] memory recipients = new address[](3);
    //     recipients[0] = r1;
    //     recipients[1] = r2;
    //     recipients[2] = r3;

    //     uint256[] memory amounts = new uint256[](3);
    //     amounts[0] = 1 ether;
    //     amounts[1] = 1 ether;
    //     amounts[2] = 1 ether;

    //     vm.prank(sender);
    //     bt.batchTransfer{value: 3 ether}(recipients, amounts);
    // }
}
