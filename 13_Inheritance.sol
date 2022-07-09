// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
   1. Inheritance allows a contract to inherit attributes(variables) and methods(functions) from any other contract.

   2. Solidity supports multiple inheritance

   3. Child contracts can override parent functions by using 'override' keyword

   4. Only functions marked as 'virtual' can be overridden by child contracts

   5. Order of inheritance matters

*/

contract A {
    // top level parent contract
    // virtual marks this function to be able to be overridden by child contract
    function foo() public pure virtual returns (string memory) {
        return "contract A";
    }
}

// B inherits A
contract B is A {
    // override A.foo()
    function foo() public pure override returns (string memory) {
        return "contract B";
    }
}

contract C is A {
    // similar to contract B above
    function foo() public pure virtual override returns(string memory) {
        return "contract C";
    }
}

contract D {

}