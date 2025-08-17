// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionTest is Test {
    Auction public auction;

    address alice = makeAddr("alice");
    uint256 startTime;
    event BidPlaced(address indexed bidder, uint256 bidAmount);

    function setUp() public {
        startTime = block.timestamp;
        auction = new Auction("New Reward", 1 hours);
        vm.deal(alice, 10 ether);
    }

    function test_isBiddingActive() public view {
        assertTrue(auction.isBiddingActive());
    }

    function test_timeLeftOverPeriod() public {
        assertTrue(auction.timeLeft() == 1 hours);

        vm.warp(startTime + 30 minutes);
        assertEq(auction.timeLeft(), 30 minutes);

        vm.warp(startTime + 1 hours);
        assertEq(auction.timeLeft(), 0);
    }

    function test_bid() public {
        vm.prank(alice);
        auction.bid{value: 1 ether}();
        assertTrue(auction.highestBid() == 1 ether);
        assertTrue(auction.highestBidder() == alice);
    }

    function test_cannotBidAfterDeadline() public {
        vm.warp(startTime + 1 hours + 1);
        vm.prank(alice);
        vm.expectRevert("The bidding is ended");
        auction.bid{value: 1 ether}();
    }

    function test_bidEmitsEvent() public {
        // Expect the BidPlaced event to be emitted
        // Parameters: checkTopic1, checkTopic2, checkTopic3, checkData
        vm.expectEmit(true, false, false, true);
        emit BidPlaced(alice, 1 ether);

        vm.prank(alice);
        auction.bid{value: 1 ether}();
    }
}
