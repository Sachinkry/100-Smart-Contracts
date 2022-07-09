// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

contract Enum {
    // enums representing different possible shipping states
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    // declare a variable of the type Status
    // this can only contain one of the predefined values
    Status public status;

    // since enums are internally represented by uints
    // this function will always return a uint
    // Pending = 0
    // Shipped = 1
    // Accepted = 2
    // Canceled = 4
    // Value higher than 4 can't be returned
    function get() public view returns (Status) {
        return status;
    }

    // Pass a uint for input to update the value
    function set(Status _status) public {
        status = _status;
    }

    // Update value to a specific enum members
    function cancel() public {
        status = Status.Canceled; //will set status 4
    }

    function reset() public {
        delete status;
    }
}

contract Enums {
    enum Status {
        None, 
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }

    Status public status;

    struct Order {
        address buyer;
        Status status;
    }

    Order[] public orders;

    function get() view external returns (Status) {
        return status;
    }

    function set(Status _status) external {
        status = _status;
    }

    function ship() external {
        status = Status.Shipped;
    }

    function reset() external {
        delete status;
    }
}