// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

// boolean
// uint
// int
// address

contract Primitives {
    bool public boo = true;

    function changeBool() public {
        boo = !boo;
    }

    function getBool() public view returns (bool) {
        return boo;
    }

    uint8 u8 = 255;
    uint16 u16 = 300;
    uint256 u256 = 437534543;

    address public addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    int8 i8 = 127;

    int public minInt = type(int).min;
    int public maxInt = type(int).max;


}