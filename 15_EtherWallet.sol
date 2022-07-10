// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }
    // 1. anyone can send ether to this contract
    receive() external payable {}


    // get balance
    function getBalance() external view returns (uint) {
        return address(this).balance;        
    }


    // 2. only owner can withdraw ether from this contract
    function withdrawEth( uint _amount) external payable {
        require(msg.sender == owner, "not an owner");
        (bool sent,) = (msg.sender).call{value: _amount}("");
        require(sent, "call failed");
    }
}