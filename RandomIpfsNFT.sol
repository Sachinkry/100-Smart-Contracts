// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomIpfsNFT is VRFConsumerBaseV2, ERC721URIStorage, Ownable {

    // Type declaration
    enum Breed {
        PUG,
        SHIBA_INU,
        ST_BERNARD
    }
    // 1. Request a random num

    // chainlink variables
    // create an instance of vrfCoordinatorInterface
    // subscription id
    // keyHash
    // minNumConfirmation (block confirmation)- [3, 200] -recommended
    // callbackGasLimit- [0, maxGasLimit]
    // num    - no of words/num to get
    VRFCoordinatorV2Interface private immutable COORDINATOR;
    uint64 private immutable subscriptionId;
    bytes32 private immutable  keyHash;
    uint32 private immutable callbackGasLimit;
    uint16 private constant NUM_BLOCK_CONFIRMATIONS = 3;
    uint16 public constant NUM_WORDS = 1;

    // NFT Variables
    // mintfee
    // rand num range
    // tokenId/tokenCounter
    uint256 internal immutable mintFee;
    uint256 internal constant MAX_CHANCE_VALUE = 100; 
    uint256 public token_Counter;
    string[] internal s_dogTokenUris;
    bool private s_initialized;
    // map the requestId to caller of the requestnFT function
    mapping(uint256 => address) public s_requestIdToSender;

    // EVENTS
    event NftRequested(uint256 indexed requestId, address sender);
    event NftMinted(Breed breed, address minter);

    constructor(
        address _vrfCoordinator,
        uint64 _subscriptionId,
        bytes32 _keyHash,
        uint32 _callbackGasLimit,
        uint256 _mintFee,
        string[3] memory dogTokenUris
    )   VRFConsumerBaseV2(_vrfCoordinator) 
        ERC721("Random Ipfs NFT", "RIN") 
    {
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        callbackGasLimit = _callbackGasLimit;
        mintFee = _mintFee;
        _initializeContract (dogTokenUris);
    }

    function requestNFT() public payable returns (uint256 requestId) {
        require(msg.value > mintFee, "Not enough Eth sent!");

        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            NUM_BLOCK_CONFIRMATIONS,
            callbackGasLimit,
            NUM_WORDS
        );
        
        s_requestIdToSender[requestId] = msg.sender;
        emit NftRequested(requestId, msg.sender);
    }

    function fulfillRandomWords(
        uint256 requestId, 
        uint256[] memory randomWords
    ) internal override {
        address nftOwner = s_requestIdToSender[requestId];
        uint256 newTokenId = token_Counter + 1; 
        uint256 moddedRange = randomWords[0] % MAX_CHANCE_VALUE;

        Breed breed = getBreedFromModdedRange(moddedRange);
        _safeMint(nftOwner, newTokenId);
        _setTokenURI(newTokenId, s_dogTokenUris[uint256(breed)]);
        emit NftMinted(breed, nftOwner);
    }

    function getBreedFromModdedRange(uint256 _moddedRange) public returns (Breed) {
        uint256 cumulativeSum = 0;
        uint[3] memory chanceArray = [10, 40, MAX_CHANCE_VALUE];
        // Pug = 0-9 (10%)
        // Shiba-inu = 10-39 (30%)
        // St.Bernard = 40-99 (60%)
        for (uint256 i = 0; i < chanceArray.length; i++) {
            if(_moddedRange >= cumulativeSum && _moddedRange < chanceArray[i]){
                return Breed(i);
            }
            cumulativeSum = chanceArray[i];
        }
    }
    function _initializeContract(string[3] memory dogTokenUris) private {
        
        s_dogTokenUris = dogTokenUris;
        s_initialized = true;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "eth sent failed!");
    }

    function getMintFee() public view returns (uint256) {
        return mintFee;
    }

    function getDogTokenUris(uint256 index) public view returns (string memory){
        return s_dogTokenUris[index];
    }

    function getInitialized() public view returns (bool) {
        return s_initialized;
    }

    function getTokenCounter() public view returns (uint256) {
        return token_Counter;
    }
}
