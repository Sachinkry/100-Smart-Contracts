// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

contract Mapping {
    // map address to uint(balances)
    mapping(address => uint) public balances;
    // map the address to true or false(bool)
    mapping(address => bool) public inserted;
    // an array to store the addresses
    address[] public keys;

    // function to add balance to addresses
    function set(address _key, uint _val) public {

       // set balances to address
       balances[_key] = _val;
       // check if this address exists or not
       // if no, push it to the array of addresses
       if(!inserted[_key]) {
           inserted[_key] = true;
           keys.push(_key);
       }
    }
    // get the size of the array
    function getSize() public view returns (uint){
        return keys.length;
    }

    function getFirst (address _key) public view returns (address, uint) {
        return (_key, balances[keys[0]]);
    }
    
}