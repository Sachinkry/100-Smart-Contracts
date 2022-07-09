// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Events {
    // declare an event which logs an address and a string 
    event TestCalled(address sender, string message);

    function test() public {
        // Log an event
        emit TestCalled((msg.sender), "Someone called test");
    }
}