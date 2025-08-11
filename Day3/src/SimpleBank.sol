// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleBank {
    /*
    Features covered ->

    1. register to use a bank -> become customer.
    2. customers add their money in the bank
    3. customers can withdraw their money from bank.
    4. registered customers can transfer money to any  registered customers in the bank.
    5. registered users can check their balance.
    */

    mapping(address => uint256) public userBalance;
    mapping(address => bool) public isRegistered;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event UserRegistered(address indexed user);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    error NotRegistered();
    error AlreadyRegistered();
    error RecipientNotRegistered();
    error InsufficientBalance();
    error ZeroAmount();
    error SelfTransfer();

    modifier onlyRegistered() {
        if (!isRegistered[msg.sender]) revert NotRegistered();
        _;
    }

    function register() external {
        if (isRegistered[msg.sender]) revert AlreadyRegistered();
        isRegistered[msg.sender] = true;
        emit UserRegistered(msg.sender);
    }

    function deposit() external payable onlyRegistered {
        if (msg.value == 0) revert ZeroAmount();
        userBalance[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyRegistered {
        if (amount == 0) revert ZeroAmount();
        if (userBalance[msg.sender] < amount) revert InsufficientBalance();
        unchecked {
            userBalance[msg.sender] -= amount;
        }
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "ETH send failed"); // if you keep `transfer`, drop this change
        emit Withdrawn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) external onlyRegistered {
        if (!isRegistered[to]) revert RecipientNotRegistered();
        if (to == msg.sender) revert SelfTransfer();
        if (amount == 0) revert ZeroAmount();
        if (userBalance[msg.sender] < amount) revert InsufficientBalance();
        unchecked {
            userBalance[msg.sender] -= amount;
            userBalance[to] += amount;
        }
        emit Transferred(msg.sender, to, amount);
    }

    function bankTotalAmount() external view returns (uint256) {
        return address(this).balance;
    }
}
