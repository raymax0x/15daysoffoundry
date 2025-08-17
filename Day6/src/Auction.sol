//SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

contract Auction {
    address public owner;
    string public biddingItem;
    uint256 public deadline;
    uint256 public highestBid;
    address public highestBidder;

    event BidPlaced(address indexed bidder, uint256 bidAmount);

    constructor(string memory _bidItem, uint256 duration) {
        owner = msg.sender;
        biddingItem = _bidItem;
        deadline = block.timestamp + duration;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp > deadline) return 0;
        uint256 leftT = deadline - block.timestamp;
        return leftT;
    }

    function isBiddingActive() public view returns (bool) {
        if (block.timestamp >= deadline) {
            return false;
        } else {
            return true;
        }
    }

    function bid() public payable {
        require(isBiddingActive(), "The bidding is ended");
        require(msg.value > highestBid, "Make higher bids");
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit BidPlaced(msg.sender, msg.value);
    }
}
