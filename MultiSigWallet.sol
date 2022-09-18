// SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract MultiSigWallet {
    // specification for multisig wallet
    // 1. submit a transaction
    // 2. approve and revoke apporval of pending transactions
    // 3. anyone can execute a trasaction after enough owners has approved it


    // Events
    event Deposit(address indexed sender, uint256 amount, uint256 contractBalance);

    event TransactionCreated(
        address indexed creator,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );

    event TransactionApproved(address indexed owner, uint256 indexed txIndex);
    event TransactionRevoked(address indexed owner, uint256 indexed txIndex);
    event TransactionExecuted(address indexed owner, uint256 indexed txIndex);


    // owners of the wallet
    address[] public owners;
    mapping(address => bool) public isOwner;
    // to check if one of the owners has approved the transaction
    mapping(uint256 => mapping(address => bool)) public isApproved;
    uint256 public numConfirmationsRequired;

    // transaction related data in a struct
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }
    Transaction[] public transactions;

    // mappings
    modifier onlyOwner {
        require(isOwner[msg.sender], "Not the owner!!");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "tx doesn't exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(
            !transactions[_txIndex].executed,
            "tx already executed"
        );
        _;
    }

    modifier notApproved(uint256 _txIndex) {
        require(!isApproved[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    // constructor
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 &&
            _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for(uint i = 0; i < _owners.length; i++){
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    // Create a transaction: only one of the owners call call this function
    function createTransaction(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit TransactionCreated(msg.sender, txIndex, _to, _value, _data);
    }

    // approve a transaction
    function approveTransaction(
        uint256 _txIndex
    )   public
        onlyOwner 
        txExists(_txIndex) 
        notExecuted(_txIndex) 
        notApproved(_txIndex) 
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isApproved[_txIndex][msg.sender] = true;

        emit TransactionApproved(msg.sender, _txIndex);
    }

    // function execute Transaction
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot executed tx"
        ); 
        transaction.executed = true;

        (bool sent, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(sent, "Failed to send ether!");

        emit TransactionExecuted(msg.sender, _txIndex);
    }

    // function to revoke a transaction
    function revokeTransaction(uint _txIndex) 
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(isApproved[_txIndex][msg.sender], "tx not approved");

        transaction.numConfirmations -= 1;
        isApproved[_txIndex][msg.sender] = false;

        emit TransactionRevoked(msg.sender, _txIndex);
    }

    // function to get owners
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

}
