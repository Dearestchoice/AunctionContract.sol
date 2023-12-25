// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public owner;
    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public bids;

    event BidPlaced(address bidder, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function placeBid() public payable {
        require(msg.value > highestBid, "Bid must be higher than the current highest bid");

        if (highestBidder != address(0)) {
            // Refund the previous highest bidder
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        bids[msg.sender] += msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() public {
        require(msg.sender != highestBidder, "You cannot withdraw while being the highest bidder");

        uint amoun t = bids[msg.sender];
        require(amount > 0, "You have no funds to withdraw");

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() public onlyOwner {
        require(highestBidder != address(0), "Auction has not started");

        // Transfer the funds to the owner
        payable(owner).transfer(highestBid);

        // Reset auction state
        highestBidder = address(0);
        highestBid = 0;
    }
}
