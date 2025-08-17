// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract BatchOptimized {
    /// @notice Maximum number of recipients allowed in a single batch
    uint8 public constant MAX_RECIPIENTS = 50;

    /// @notice Transfer ETH to multiple recipients in one transaction
    /// @param recipients Array of recipient addresses (max 50)
    /// @param amounts Array of ETH amounts in wei as uint128 (max ~340 trillion ETH each)
    function batchTransfer(
        address[] calldata recipients,
        uint128[] calldata amounts
    ) external payable {
        uint8 len = uint8(recipients.length);
        require(len == amounts.length, "Length mismatch");
        require(len > 0 && len <= MAX_RECIPIENTS, "Invalid array length");

        uint128 total;

        // Single loop: validate, accumulate total, and transfer
        for (uint8 i; i < len; ) {
            uint128 amount = amounts[i];
            address recipient = recipients[i];

            // Validate (cheaper to fail early)
            require(amount > 0, "Zero amount");
            require(recipient != address(0), "Zero address");

            total += amount;

            // Transfer
            (bool success, ) = recipient.call{value: amount}("");
            require(success, "Transfer failed");

            unchecked {
                ++i;
            }
        }

        require(uint256(total) == msg.value, "Incorrect ETH sent");
    }
}
