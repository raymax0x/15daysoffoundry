// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MyToken, TokenSwap} from "../src/SimpleBank.sol";

contract SimpleBankTest2 is Test {
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

    function test_swap_A_for_B() {
        address new_user = makeAddr("new_user");
        tokenA.transfer(address(new_user), 20 ether);

        vm.startPrank(new_user);
        tokenSwap.swap(tokenA, 10 ether);
        vm.stopPrank();

        // assert 10 ether tokenB is added to the msg.sender
        assertEq(tokenB.balanceOf(new_user), 10 ether);

        // assert 10 ether tokenA is added to the tokenSwap contract balance.
        assertEq(tokenA.balanceOf(tokenSwap), 1010 ether);
        assertEq(tokenB.balanceOf(tokenSwap), 9090 ether);
    }
}
