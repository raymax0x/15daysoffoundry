// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Greeting {
    string public greetMsg = "Hello";

    function setNewGreetMsg(string memory _newMsg) public {
        greetMsg = _newMsg;
    }
}
