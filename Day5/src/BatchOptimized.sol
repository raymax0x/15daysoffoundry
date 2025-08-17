// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract BatchOptimized {
    /// @notice Transfer ETH to multiple recipients in one transaction
    /// @param recipients Array of recipient addresses
    /// @param amounts Array of ETH amounts (in wei) to send
    function batchTransfer(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) external payable {
        require(recipients.length == amounts.length, "Length mismatch");

        uint256 total = 0;
        uint256 len = recipients.length;

        // Calculate the total amount
        for (uint256 i = 0; i < len; ) {
            total += amounts[i];
            unchecked {
                i++;
            }
        }

        require(total == msg.value, "Incorrect ETH sent");

        // Perform the transfers
        for (uint256 i = 0; i < len; ) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "Transfer failed");
            unchecked {
                i++;
            }
        }
    }
}
