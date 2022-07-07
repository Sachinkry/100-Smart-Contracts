// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

// require, revert, assert
// REQUIRE: is used to validate inputs and conditions before execution
// REVERT: very similar to revert
// ASSERT: is used to check for code that should never be false 

// - gas refund, state updates are reverted
// custom error - save gas 

contract Error {
    // REQUIRE
    function testRequire(uint _i) public pure {
        require(_i <= 10, "i > 10");
        //code
    }

    // REVERT is used when there are more conditions to check
    function testRevert(uint _i) public pure {
        if (_i > 10) {
            revert("i > 10");
        }
    }

    // ASSERT
    uint public num = 123;

    function testAssert() public view {
        assert(num == 123);
    }

    function foo(uint _i) public {
        num += 1;
        require(_i < 10);
    }

    // CUSTOM ERROR: example 1
    error MyError(address caller, uint _i);

    function testCustomError(uint _i) public view {
        if (_i > 10) {
            revert MyError(msg.sender, _i);
        }
    }

    // CUSTOM ERROR: example 1 
    error InsufficientBalance(uint balance, uint withdrawAmount);

    function testCustomError2(uint _withdrawAmount) public view {
        uint bal = address(this).balance;
        if(bal < _withdrawAmount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
        }
    }
}

