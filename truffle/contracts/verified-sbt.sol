// license: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Proof of Solvency Token
contract PoS_token is ERC721 {

    mapping (address => bool) private _isMinter; // can mint tokens
    mapping (address => bool) private _isBurner; // can burn tokens even if they are not the owner
    mapping (address => bool) private _isAdmin; // admin can add and delete admins, set and unset minters and burners


    mapping (uint256 => address) private _owner; // link the sbt to a certain owner
    mapping (uint256 => address) private _token; // link the sbt to a certain token

    mapping (uint256 => string) private _tokenURI; // uri where we can get the addresses used to generate the proof
    mapping (uint256 => string) private _verifier; // could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)

    mapping (uint256 => uint256) private _signature; // zk proof generated in the frontend (not verified yet)
    mapping (uint256 => uint256) private _timestamp; // timestamp of the minting of the proof

    mapping (uint256 => bytes32) private _merkleRoot; // merkle root of the addresses (to ensure that the addresses have not been modified)


    uint256 private _tokenId;
    string private _name;
    string private _symbol;

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

        _isAdmin[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
        _isBurner[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
        _isMinter[0x9198aEf8f3019f064d0826eB9e07Fb07a3d3a4BD] = true;
    }

    /**
    * @param from is the current owner of the NFT
    * @param to is the new owner of the NFT
    * @param tokenId is the NFT to transfer
    * safeTransferFrom and transferFrom are disabled because the nft is a sbt
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    function transferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }

    /**
    * approve is disabled because the nft is a sbt and cannot be transfered
    */
    function approve(address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    /**
    * getApproved is disabled because the nft is a sbt and cannot be transfered
    */
    function getApproved(uint256 tokenId) public view override returns (address operator) {
        revert("No one can transfer this token");
        return address(0);
    }
    /**
    * setApprovalForAll is disabled because the nft is a sbt and cannot be transfered
    */
    function setApprovalForAll(address operator, bool _approved) public pure override {
        revert("No one can transfer this token");
    }
    /**
    * isApprovedForAll is disabled because the nft is a sbt and cannot be transfered -> the output will always be false
    */
    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return false;
    }


    // mint and burn sbt

    /**
    * @param receiver is the address of the receiver of the sbt
    * @param token is the address of the token that is linked to the sbt
    * @param tokenURI is the uri where we can get the addresses used to generate the proof (stored on ipfs)
    * @param merkleRoot is the merkle root of the addresses (to ensure that the addresses have not been modified)
    * @param signature is the zk proof generated in the frontend (which has been verified by the verifier)
    * @param verifier is a string which could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)
    * mint a new sbt
    */
    function mint(address receiver, address token, string memory tokenURI, bytes32 merkleRoot, uint256 signature, string memory verifier) public {
        require(_isMinter[msg.sender], "You are not a minter");

        _owner[_tokenId] = receiver;
        _token[_tokenId] = token;
        _tokenURI[_tokenId] = tokenURI;
        _merkleRoot[_tokenId] = merkleRoot;
        _signature[_tokenId] = signature;
        _timestamp[_tokenId] = block.timestamp;
        _verifier[_tokenId] = verifier;
        _tokenId++;

        emit Mint(receiver, _tokenId);
    }

    /**
    * @param tokenId is the id of the sbt to burn
    * burn an sbt
    */
    function burn(uint256 tokenId) public {
        require(_owner[tokenId] == msg.sender || _isBurner[msg.sender], "You are not allowed to burn this token");

        delete _owner[tokenId];
        delete _tokenURI[tokenId];
        delete _merkleRoot[tokenId];
        delete _signature[tokenId];
        delete _timestamp[tokenId];
        delete _token[tokenId];

        emit Burn(msg.sender, tokenId);
    }

    // get sbt data    

    /**
    * @param tokenId is the id of the sbt
    * @return _merkleRoot associated to the sbt
    */
    function getMerkleRoot(uint256 tokenId) public view returns (bytes32) {
        return _merkleRoot[tokenId];
    }
    /**
    * @param tokenId is the id of the sbt
    * @return _signature associated to the sbt
    */
    function getSignature(uint256 tokenId) public view returns (uint256) {
        return _signature[tokenId];
    }
    /**
    * @param tokenId is the id of the sbt
    * @return _tokenURI associated to the sbt
    */
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURI[tokenId];
    }
    /**
    * @param tokenId is the id of the sbt
    * @return _timestamp associated to the sbt
    */
    function getTimestamp(uint256 tokenId) public view returns (uint256) {
        return _timestamp[tokenId];
    }

        /**
    * @param tokenId is the id of the sbt
    * @return _tokenAddress associated to the sbt
    */
    function getTokenAddress(uint256 tokenId) public view returns (address) {
        return _token[tokenId];
    }

    // admin functions
    /**
    * @param admin is the address of the admin to add/remove
    * @param isAdmin is true if the admin is added, false if the admin is removed
    */
    function editAdmin(address admin, bool isAdmin) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isAdmin[admin] = isAdmin;
    }
    /**
    * @param minter is the address of the minter to add/remove
    * @param isMinter is true if the minter is added, false if the minter is removed
    */
    function editMinter(address minter, bool isMinter) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isMinter[minter] = isMinter;
    }
    /**
    * @param burner is the address of the burner to add/remove
    * @param isBurner is true if the burner is added, false if the burner is removed
    */
    function editBurner(address burner, bool isBurner) public {
        require(_isAdmin[msg.sender], "You are not an admin");
        _isBurner[burner] = isBurner;
    }
}