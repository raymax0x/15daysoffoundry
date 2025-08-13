// SPDX-LICENSE-IDENTIFIER: MIT

pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swap(address _tokenIn, uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            _tokenIn == address(tokenA) || _tokenIn == address(tokenB),
            "Invalid input token"
        );

        IERC20 tokenIn = IERC20(_tokenIn);
        IERC20 tokenOut = (_tokenIn == address(tokenA)) ? tokenB : tokenA;

        // The TokenSwap contract needs to have been approved by the user
        // to spend their tokens. This is a standard ERC20 workflow.
        tokenIn.transferFrom(msg.sender, address(this), _amount);

        // Transfer the other token to the user
        tokenOut.transfer(msg.sender, _amount);
    }
}
