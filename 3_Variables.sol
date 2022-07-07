// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Variables {
    // State variables are stored on the blockchain.
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public view returns ( uint, uint, address) {
        // Local variables are not saved to the blockchain.
        uint i = 456;

        // Here are some global variables
        uint timestamp = block.timestamp; // Current block timestamp
        uint blockNum = block.number;  // current block number
        address sender = msg.sender; // address of the caller

        return (timestamp, blockNum, sender);
    }
}