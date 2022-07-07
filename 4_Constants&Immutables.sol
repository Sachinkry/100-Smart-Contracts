// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

// Constant variables: declaration and initialization at the same time;

// Immutable varibles: no need to initialize while declaring the varible
// initialize while declaration or 
// can be assigned using constructor

contract Constants {
    bool public constant BOO = true; 
    

    // function changeBool() public {
    //     // cannot change value of boo(it's constant)
    //     BOO = !BOO;     // will not compile    
    // }
}

contract Immutable {
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint)  {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}

