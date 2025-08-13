// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/TokenSwap.sol";
import "../src/MyToken.sol";

contract TokenSwapTest is Test {
    MyToken public tokenA;
    MyToken public tokenB;
    TokenSwap public tokenSwap;

    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function setUp() public {
        // 1. Deploy Tokens
        tokenA = new MyToken("Token A", "TKA", INITIAL_SUPPLY);
        tokenB = new MyToken("Token B", "TKB", INITIAL_SUPPLY);

        // 2. Deploy TokenSwap
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        // 3. Fund the TokenSwap contract with liquidity (giving a reserve of 100 tokens of each)
        tokenA.transfer(address(tokenSwap), 100 ether);
        tokenB.transfer(address(tokenSwap), 100 ether);

        // 4. Approve the TokenSwap contract to spend our test contract's tokens
        tokenA.approve(address(tokenSwap), type(uint256).max);
        tokenB.approve(address(tokenSwap), type(uint256).max);
    }

    function test_swap_A_for_B_from_new_user() public {
        address new_user = makeAddr("new_user");
        tokenA.transfer(address(new_user), 20 ether);

        vm.startPrank(new_user);
        tokenA.approve(address(tokenSwap), 20 ether);
        tokenSwap.swap(address(tokenA), 10 ether);
        vm.stopPrank();

        // assert 10 ether tokenB is added to the msg.sender
        assertEq(tokenB.balanceOf(new_user), 10 ether);

        // assert 10 ether tokenA is added to the tokenSwap contract balance.
        assertEq(tokenA.balanceOf(address(tokenSwap)), 110 ether);
        assertEq(tokenB.balanceOf(address(tokenSwap)), 90 ether);
    }

    function test_swap_A_for_B_from_test_contract() public {
        uint256 swapAmount = 10 ether;
        console2.log("--- Starting test_swap_A_for_B ---");

        // Check initial balances
        uint256 initialUserBalanceA = tokenA.balanceOf(address(this));
        uint256 initialUserBalanceB = tokenB.balanceOf(address(this));
        console2.log("Initial User Token A Balance:", initialUserBalanceA);
        console2.log("Initial User Token B Balance:", initialUserBalanceB);

        // Perform the swap
        console2.log("Swapping", swapAmount, "of Token A for Token B...");
        tokenSwap.swap(address(tokenA), swapAmount);
        console2.log("Swap complete.");

        // Check final balances
        uint256 finalUserBalanceA = tokenA.balanceOf(address(this));
        uint256 finalUserBalanceB = tokenB.balanceOf(address(this));
        console2.log("Final User Token A Balance:", finalUserBalanceA);
        console2.log("Final User Token B Balance:", finalUserBalanceB);

        assertEq(
            finalUserBalanceA,
            initialUserBalanceA - swapAmount,
            "User Token A balance should decrease"
        );
        assertEq(
            finalUserBalanceB,
            initialUserBalanceB + swapAmount,
            "User Token B balance should increase"
        );
    }
}
