// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

// Array - dynamic or fixed size
// initialization
// insert(push), get, update, delete, pop, length
// creating an array in memory
// returning array from function

contract Array {
    uint[] public nums = [2, 5, 3, 9];
    uint[3] public numsFixed = [67, 34, 56]; // an array of not more than 3 elements

    function examples() public {
        nums.push(45);    // [2, 5, 3, 9, 45]
        uint x = nums[1];  // 5
        nums[2] =  777;   // [1, 2, 777, 9, 45] 
        delete nums[1];   // [1, 0, 777, 9, 45]
        nums.pop();       // [1, 0, 777, 9]
        uint len = nums.length;  // 4

        // create array in memory
        // they are of fixed size, so you can't pop or push :-)
        uint[] memory a = new uint[](5);
        a[1] = 123;
    }

    function returnArray() public view returns (uint[] memory) {
        return nums;
    }
}


// remove an element from an array and 
// shrink the array
// it's not gas efficient but preserves the order of the array elements
contract ArrayShift {
    uint[] public arr;

    function example() public {
        arr = [1, 2, 3];
        delete arr[1];  // [1, 0, 3]
    }

    // [1,2,3] -> remove(1) -> [1,3,3] -> [1,3]
    // [1,2,3,4,5,6] -> remove(2) -> [1,2,4,5,6,6] -> [1,2,4,5,6]
    // [1] -> remove(0) -> [1] -> []
    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length -1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1,2,3,4,5];
        remove(2);
        // [1,2,4,5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}

// another way to remove an element 
// this is gas efficient but does not 
// preserves the order of the elements in the array
contract ArrayReplaceLast {
    uint[] public arr;

    // [1,2,3,4] -> remove(1) -> [1,4,3]
    // [1,4,3] -> remove(2) -> [1,4]
    function remove(uint _index) public {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }

    function test() external {
        arr = [1,2,3,4];

        remove(1);

        // [1,4,3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);
    }
} 