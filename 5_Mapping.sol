// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

// contract Mapping {
//     //mapping from uint to address
//     mapping(uint => address) public myMap;

//     function get(uint _i) public view returns (address) {
//         // mapping always returns a value
//         // if value was never set, then it returns the default value
//         return myMap[_i];
//     }

//     function set(address _addr, uint _i) public {
//         myMap[_i] = _addr;
//     }

// }

contract nestedMapping {
    // mapping from address to another mapping
    mapping(address => mapping(uint => bool)) public nested;

    function get(address _addr, uint _i) public view returns (bool) {
        return nested[_addr][_i];
    }

    function set(address _addr, uint _i, bool _boo) public {
        nested[_addr][_i] = _boo;
    }

    function remove(address _addr, uint _i) public {
        delete nested[_addr][_i];
    }
}


// What is mapping? => store data as key-value pair
// Why? 
// How? => it's syntax is: mapping(keyType => valueType) nameOfMaping;
// keyType can be a value, string, byte or any contract
// valueType can be any type including another mapping or an array