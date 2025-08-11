// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

/**
 * SimpleBankTest
 *
 * Test suites:
 * A. Registration (1–2)
 * B. Access Control: onlyRegistered (3–5)
 * C. Deposit (6, 11)
 * D. Withdraw (7–8, 12)
 * E. Transfer (9, 13, 15–16)
 * F. Accounting / Bank total (14)
 * G. Fuzz (17–18)
 *
 * Total tests: 18
 */
contract SimpleBankTest is Test {
    SimpleBank public bank;

    // Common test actors generated on demand in tests
    // (We keep helpers flexible; no fixed addresses here.)

    function setUp() public {
        bank = new SimpleBank();
    }

    // ------------------------
    // Helpers
    // ------------------------
    function _register(address user) internal {
        vm.prank(user);
        bank.register();
    }

    function _registerAndFund(address user, uint256 amount) internal {
        vm.deal(user, amount);
        vm.prank(user);
        bank.register();
    }

    function _deposit(address user, uint256 amount) internal {
        vm.prank(user);
        bank.deposit{value: amount}();
    }

    // =========================================================
    // A. Registration
    // =========================================================

    /// (1) Registering marks caller as registered.
    function testA1_Register_SetsFlag() public {
        bank.register();
        assertTrue(bank.isRegistered(address(this)));
    }

    /// (2) Registering twice reverts with AlreadyRegistered.
    function testA2_Register_Revert_AlreadyRegistered() public {
        bank.register();
        vm.expectRevert(SimpleBank.AlreadyRegistered.selector);
        bank.register();
    }

    // =========================================================
    // B. Access Control: onlyRegistered
    // =========================================================

    /// (3) Unregistered user: deposit() reverts NotRegistered.
    function testB1_Deposit_Revert_NotRegistered() public {
        address alice = makeAddr("alice");
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        vm.expectRevert(SimpleBank.NotRegistered.selector);
        bank.deposit{value: 1 ether}();
    }

    /// (4) Unregistered user: withdraw() reverts NotRegistered.
    function testB2_Withdraw_Revert_NotRegistered() public {
        address alice = makeAddr("alice");
        vm.prank(alice);
        vm.expectRevert(SimpleBank.NotRegistered.selector);
        bank.withdraw(10);
    }

    /// (5) Unregistered user: transfer() reverts NotRegistered.
    function testB3_Transfer_Revert_NotRegistered() public {
        address alice = makeAddr("alice");
        address bob = makeAddr("bob");
        vm.prank(alice);
        vm.expectRevert(SimpleBank.NotRegistered.selector);
        bank.transfer(bob, 10);
    }

    // =========================================================
    // C. Deposit
    // =========================================================

    /// (6) Deposit of 0 reverts ZeroAmount.
    function testC1_Deposit_Revert_ZeroAmount() public {
        address alice = makeAddr("alice");
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);
        bank.register();
        vm.expectRevert(SimpleBank.ZeroAmount.selector);
        bank.deposit{value: 0}();
        vm.stopPrank();
    }

    /// (11) Successful deposit updates mapping and emits event.
    function testC2_Deposit_EmitsAndUpdatesBalance() public {
        address alice = makeAddr("alice");
        _registerAndFund(alice, 2 ether);

        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Deposited(alice, 1 ether);
        _deposit(alice, 1 ether);

        assertEq(bank.userBalance(alice), 1 ether);
        assertEq(bank.bankTotalAmount(), 1 ether);
    }

    // =========================================================
    // D. Withdraw
    // =========================================================

    /// (7) Withdraw of 0 reverts ZeroAmount.
    function testD1_Withdraw_Revert_ZeroAmount() public {
        address alice = makeAddr("alice");
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);
        bank.register();
        vm.expectRevert(SimpleBank.ZeroAmount.selector);
        bank.withdraw(0);
        vm.stopPrank();
    }

    /// (8) Withdraw > balance reverts InsufficientBalance.
    function testD2_Withdraw_Revert_InsufficientBalance() public {
        address alice = makeAddr("alice");
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);
        bank.register();
        vm.expectRevert(SimpleBank.InsufficientBalance.selector);
        bank.withdraw(2 ether);
        vm.stopPrank();
    }

    /// (12) Successful withdraw updates mapping/bank total and emits.
    function testD3_Withdraw_Succeeds_UpdatesAndEmits() public {
        address alice = makeAddr("alice");
        _registerAndFund(alice, 3 ether);
        _deposit(alice, 2 ether);

        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Withdrawn(alice, 1 ether);

        vm.prank(alice);
        bank.withdraw(1 ether);

        assertEq(bank.userBalance(alice), 1 ether);
        assertEq(bank.bankTotalAmount(), 1 ether);
    }

    // =========================================================
    // E. Transfer
    // =========================================================

    /// (9) Transfer > balance reverts InsufficientBalance.
    function testE1_Transfer_Revert_InsufficientBalance() public {
        address alice = makeAddr("alice");
        address bob = makeAddr("bob");

        hoax(alice, 1 ether); // prank + fund for next call only
        bank.register();

        vm.prank(bob);
        bank.register();

        vm.prank(alice);
        vm.expectRevert(SimpleBank.InsufficientBalance.selector);
        bank.transfer(bob, 2 ether);
    }

    /// (13) Successful transfer updates both balances and emits.
    function testE2_Transfer_Succeeds_UpdatesAndEmits() public {
        address alice = makeAddr("alice");
        address bob = makeAddr("bob");
        _registerAndFund(alice, 3 ether);
        _register(bob);
        _deposit(alice, 2 ether);

        vm.expectEmit(true, true, false, true);
        emit SimpleBank.Transferred(alice, bob, 1 ether);

        vm.prank(alice);
        bank.transfer(bob, 1 ether);

        assertEq(bank.userBalance(alice), 1 ether);
        assertEq(bank.userBalance(bob), 1 ether);
        assertEq(bank.bankTotalAmount(), 2 ether); // internal transfer; contract balance unchanged
    }

    /// (15) Transfer to unregistered recipient reverts RecipientNotRegistered.
    function testE3_Transfer_Revert_RecipientNotRegistered() public {
        address alice = makeAddr("alice");
        address bob = makeAddr("bob"); // unregistered
        _registerAndFund(alice, 2 ether);
        _deposit(alice, 1 ether);

        vm.prank(alice);
        vm.expectRevert(SimpleBank.RecipientNotRegistered.selector);
        bank.transfer(bob, 1);
    }

    /// (16) Self-transfer reverts SelfTransfer.
    function testE4_Transfer_Revert_SelfTransfer() public {
        address alice = makeAddr("alice");
        _registerAndFund(alice, 2 ether);
        _deposit(alice, 1 ether);

        vm.prank(alice);
        vm.expectRevert(SimpleBank.SelfTransfer.selector);
        bank.transfer(alice, 1);
    }

    // =========================================================
    // F. Accounting
    // =========================================================

    /// (14) bankTotalAmount tracks deposits and withdrawals.
    function testF1_BankTotal_TracksDepositsAndWithdrawals() public {
        address alice = makeAddr("alice");
        address bob = makeAddr("bob");
        _registerAndFund(alice, 5 ether);
        _registerAndFund(bob, 5 ether);

        _deposit(alice, 2 ether);
        _deposit(bob, 3 ether);
        assertEq(bank.bankTotalAmount(), 5 ether);

        vm.prank(bob);
        bank.withdraw(1 ether);
        assertEq(bank.bankTotalAmount(), 4 ether);
    }

    // =========================================================
    // G. Fuzz
    // =========================================================

    /// (17) Fuzz: non-zero deposits record exact amount per user.
    function testG1_Fuzz_Deposit_NonZero(address user, uint96 amount) public {
        vm.assume(user != address(0));
        amount = uint96(bound(amount, 1, type(uint96).max));

        _registerAndFund(user, amount);
        vm.prank(user);
        bank.deposit{value: amount}();
        assertEq(bank.userBalance(user), uint256(amount));
    }

    /// (18) Fuzz: transfers respect balances; bank total stays constant.
    function testG2_Fuzz_Transfer(address a, address b, uint96 amount) public {
        vm.assume(a != address(0));
        vm.assume(b != address(0));
        vm.assume(a != b);
        amount = uint96(bound(amount, 1, 10 ether));

        _registerAndFund(a, 20 ether);
        _register(b);
        _deposit(a, 10 ether);

        vm.prank(a);
        bank.transfer(b, amount);

        assertEq(bank.userBalance(a), 10 ether - amount);
        assertEq(bank.userBalance(b), amount);
        assertEq(bank.bankTotalAmount(), 10 ether);
    }

    // ---------------------------------------------------------
    // Extra: direct balance map update check from your original
    // ---------------------------------------------------------

    /// (11b) Deposit of 5 ETH increments mapping by 5 ETH (explicit value).
    function testC2b_Deposit_MapsToExactWei() public {
        address alice = makeAddr("alice");
        vm.deal(alice, 5 ether);
        vm.startPrank(alice);
        bank.register();
        bank.deposit{value: 5 ether}();
        assertEq(bank.userBalance(alice), 5 ether);
        vm.stopPrank();
    }
}
