// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

contract BatchTransfer {
    function batchTransfer(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) external payable {
        require(recipients.length == amounts.length, "data length mismatch");

        uint256 total;
        uint256 len = recipients.length;
        for (uint256 i = 0; i < len; ) {
            total += amounts[i];
            unchecked {
                i++;
            }
        }
        require(msg.value == total, "msg.value must equal total amounts");

        for (uint256 i = 0; i < len; ) {
            (bool ok, ) = recipients[i].call{value: amounts[i]}("");
            require(ok, "ETH transfer failed");
            unchecked {
                i++;
            }
        }
    }
}

// un optimized version :
// pragma solidity ^0.8.23;

// contract BatchTransfer {
//     function _transfer(address _to, uint256 _amount) internal {
//         require(_to != address(0), "Zero address");
//         require(_amount > 0, "Amount should be greater than 0");
//         (bool ok, ) = _to.call{value: _amount}("");
//         require(ok, "ETH transfer failed");
//     }

//     function batchTransfer(address[] memory recipients, uint256[] memory amounts) public payable {
//         require(recipients.length == amounts.length, "data length mismatch");

//         uint256 total;
//         for (uint256 i = 0; i < amounts.length; i++) {
//             total += amounts[i] * 1 ether;
//         }
//         require(msg.value == total, "msg.value must equal total amounts");

//         for(uint256 i = 0; i < recipients.length; i++){
//             _transfer(recipients[i], amounts[i] * 1 ether);
//         }

//     }
// }
