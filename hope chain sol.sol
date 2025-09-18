// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract HopeChain {
    address public admin;
    uint public donationCount;

    struct Donation {
        address donor;
        uint amount;
        uint timestamp;
    }

    mapping(uint => Donation) public donations;
    mapping(address => uint) public lastDonationTime;

    event Donated(address indexed donor, uint amount, uint timestamp);
    event Withdrawn(address indexed admin, uint amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function donate() public payable {
        require(msg.value > 0, "Cannot donate zero.");
        require(block.timestamp - lastDonationTime[msg.sender] > 5 seconds, "Wait 5s before donating again.");

        donationCount++;
        donations[donationCount] = Donation(msg.sender, msg.value, block.timestamp);
        lastDonationTime[msg.sender] = block.timestamp;

        emit Donated(msg.sender, msg.value, block.timestamp);
    }
    function getLastDonationTime(address _addr) public view returns (uint) {
    return lastDonationTime[_addr];
}
function getNow() public view returns (uint) {
    return block.timestamp;
}



    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _amount) public onlyAdmin {
        require(_amount <= address(this).balance, "Insufficient funds.");
        payable(admin).transfer(_amount);

        emit Withdrawn(admin, _amount);
    }
}
