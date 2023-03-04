// license: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


// Proof of Solvency Token
contract ARS_token is ERC721 {

    mapping (address => bool) public _isMinter; // can mint tokens
    mapping (address => bool) public _isBurner; // can burn tokens even if they are not the owner
    mapping (address => bool) public _isAdmin; // admin can add and delete admins, set and unset minters and burners


    mapping (uint256 => address) public _owner; // link the sbt to a certain owner
    mapping (uint256 => address) public _token; // link the sbt to a certain token

    mapping (uint256 => string) public _tokenURI; // uri where we can get the addresses used to generate the proof
    mapping (uint256 => string) public _verifier; // could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)

    mapping (uint256 => uint256) public _value; // number of tokens owned when the proof has been generated
    mapping (uint256 => uint256) public _signature; // zk proof generated in the frontend (not verified yet)
    mapping (uint256 => uint256) public _timestamp; // timestamp of the minting of the proof

    mapping (uint256 => bytes32) public _merkleRoot; // merkle root of the addresses (to ensure that the addresses have not been modified)


    uint256 private _tokenId;
    string public _name;
    string public _symbol;

    event Mint(address indexed owner, uint256 indexed tokenId);
    event Burn(address indexed owner, uint256 indexed tokenId);

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_){
        _tokenId = 0;
        _name = name_;
        _symbol = symbol_;

        // contract creator has all the rights
        // _isAdmin[msg.sender] = true;
        // _isBurner[msg.sender] = true;
        // _isMinter[msg.sender] = true;

        // temporary : a delete dans le final
        _isAdmin[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
        _isBurner[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
        _isMinter[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
    }

    
    /**
    * @notice safeTransferFrom and transferFrom are disabled because the nft is a sbt
    * @param from is the current owner of the NFT
    * @param to is the new owner of the NFT
    * @param tokenId is the NFT to transfer
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    function transferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }

    /**
    * @notice approve is disabled because the nft is a sbt and cannot be transfered
    */
    function approve(address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    /**
    * @notice getApproved is disabled because the nft is a sbt and cannot be transfered
    */
    function getApproved(uint256 tokenId) public pure override returns (address operator) {
        revert("No one can transfer this token");
        return address(0);
    }
    /**
    * @notice setApprovalForAll is disabled because the nft is a sbt and cannot be transfered
    */
    function setApprovalForAll(address operator, bool _approved) public pure override {
        revert("No one can transfer this token");
    }
    /**
    * @notice isApprovedForAll is disabled because the nft is a sbt and cannot be transfered -> the output will always be false
    */
    function isApprovedForAll(address owner, address operator) public pure override returns (bool) {
        return false;
    }


    // mint and burn sbt

    /**
    * @notice mint a new sbt with the given caracteristics (only minters can call it)
    * @param receiver is the address of the receiver of the sbt
    * @param token is the address of the token that is linked to the sbt
    * @param value is the value the contract has verified
    * @param tokenURI is the uri where we can get the addresses used to generate the proof (stored on ipfs)
    * @param merkleRoot is the merkle root of the addresses (to ensure that the addresses have not been modified)
    * @param signature is the zk proof generated in the frontend (which has been verified by the verifier)
    * @param verifier is a string which could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)
    */
    function mint(address receiver, address token, uint256 value, string memory tokenURI, bytes32 merkleRoot, uint256 signature, string memory verifier) public {
        require(_isMinter[msg.sender], "You are not a minter");

        _owner[_tokenId] = receiver;
        _token[_tokenId] = token;
        _tokenURI[_tokenId] = tokenURI;
        _merkleRoot[_tokenId] = merkleRoot;
        _signature[_tokenId] = signature;
        _timestamp[_tokenId] = block.timestamp;
        _verifier[_tokenId] = verifier;
        _value[_tokenId] = value;

        _mint(receiver, _tokenId);
        emit Mint(receiver, _tokenId);

        _tokenId++;

    }

    /**
    * @notice delete all the caracteristics of tokenId (burn)
    * @param tokenId is the id of the sbt to burn
    */
    function burn(uint256 tokenId) public {
        require(_owner[tokenId] == msg.sender || _isBurner[msg.sender], "You are not allowed to burn this token");

        delete _owner[tokenId];
        delete _tokenURI[tokenId];
        delete _merkleRoot[tokenId];
        delete _signature[tokenId];
        delete _timestamp[tokenId];
        delete _token[tokenId];

        _burn(tokenId);
        emit Burn(msg.sender, tokenId);
    }

    // admin functions
    /**
    * @notice set or unset admin
    * @param admin is the address of the admin to add/remove
    * @param isAdmin is true if the admin is added, false if the admin is removed
    */
    function editAdmin(address admin, bool isAdmin) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isAdmin[admin] = isAdmin;
    }

    /**
    * @notice set or unset minter
    * @param minter is the address of the minter to add/remove
    * @param isMinter is true if the minter is added, false if the minter is removed
    */
    function editMinter(address minter, bool isMinter) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isMinter[minter] = isMinter;
    }
    
    /**
    * @notice set or unset burner
    * @param burner is the address of the burner to add/remove
    * @param isBurner is true if the burner is added, false if the burner is removed
    */
    function editBurner(address burner, bool isBurner) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isBurner[burner] = isBurner;
    }
}