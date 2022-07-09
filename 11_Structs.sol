// SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

contract Structs {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function examples() external {
        // different ways to initialize
        Car memory toyota = Car("Toyota", 1990, msg.sender);
        Car memory lambo = Car({year: 1980, model: "Lamborghini", owner: msg.sender});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari", 1999, msg.sender));

        Car memory _car = cars[0];
        _car.year = 2000;
        delete _car.owner;

        delete cars[1]; 
    }
}

contract TodoList {
    // Declare a struct that groups together two data types
    struct TodoItem {
        string text;
        bool completed;
    }

    // create an array of todo item structs
    TodoItem[] public todos;

    function createTodo(string memory _text) public {
        // there are multiple ways to initialize structs

        // method 1: call it like a function
        todos.push(TodoItem(_text, false));

        // method 2: explicitly set its keys
        todos.push(TodoItem({text: _text, completed: false}));

        // method 3: initialize an empty struct, then set individual properties
        TodoItem memory todo;
        todo.text = _text;
        todo.completed = false;
        todos.push(todo);
    } 

    // update a struct value
    function update(uint _index, string memory _text) public {
        todos[_index].text = _text;
    }

    // update completed
    function toggleCompleted(uint _index) public {
        todos[_index].completed = !todos[_index].completed;
    }
}