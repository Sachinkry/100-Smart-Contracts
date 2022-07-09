// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ReceiveEther {
    //function to recieve Ether.msg.data must be empty
    receive() external payable {}

    // fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}


contract SendEther {
    function sendEth(address payable _to) public payable {
        (bool success, ) = _to.call{value: 123}("");
        require(success, "call failed");
    }
}

contract Payable {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() external payable {}

    function getBalance() external payable returns (uint) {
        return address(this).balance;        
    }
}

// fallback and receive function

contract Fallback {
    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}