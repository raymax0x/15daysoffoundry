//SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "@openzeppelin-contracts/token/ERC20/ERC20.sol";

contract ERC20Mintable is ERC20 {
    constructor() ERC20("TokenA", "T(A)") {
        _mint(msg.sender, 100);
    }
}
