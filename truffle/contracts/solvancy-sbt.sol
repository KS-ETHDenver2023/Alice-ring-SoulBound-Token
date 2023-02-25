//license: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract temp_sbt is ERC721 {

    mapping (address => bool) private _isBurner; // list of addresses that can burn sbt even if they are not the owner
    mapping (address => bool) private _isAdmin; // admin can add and delete admins, set and unset minters and burners

    mapping (uint256 => address) private _owner; // link the sbt to a certain owner
    mapping (uint256 => address) private _token; // link the sbt to a certain token

    mapping (uint256 => string) private _tokenURI; // uri where we can get the addresses used to generate the proof
    mapping (uint256 => string) private _merkleRoot; // merkle root of the addresses (to ensure that the addresses have not been modified)
    mapping (uint256 => string) private _zkProof; // zk proof generated in the frontend (not verified yet)


    uint256 private _tokenId;
    string private _name;
    string private _symbol;

    event Mint(address indexed owner, uint256 indexed tokenId);
    event Burn(address indexed owner, uint256 indexed tokenId);

    constructor(string memory name_, string memory symbol_, address verifier_) ERC721(name_, symbol_){
        _tokenId = 0;
        _name = name_;
        _symbol = symbol_;
        _isBurner[verifier_] = true;
        _isAdmin[msg.sender] = true;
        _isBurner[msg.sender] = true;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    function transferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    function approve(address to, uint256 tokenId) public pure override {
        revert("No one can transfer this token");
    }
    function getApproved(uint256 tokenId) public view override returns (address operator) {
        revert("No one can transfer this token");
        return address(0);
    }
    function setApprovalForAll(address operator, bool _approved) public pure override {
        revert("No one can transfer this token");
    }
    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return false;
    }

    // mint and burn sbt
    function mint(address token, string memory tokenURI, string memory merkleRoot, string memory zkProof) public {
        _owner[_tokenId] = msg.sender;
        _token[_tokenId] = token;
        _tokenURI[_tokenId] = tokenURI;
        _merkleRoot[_tokenId] = merkleRoot;
        _zkProof[_tokenId] = zkProof;
        _tokenId++;

        emit Mint(msg.sender, _tokenId);
    }

    function burn(uint256 tokenId) public {
        require(_owner[tokenId] == msg.sender || _isBurner[msg.sender], "You are not allowed to burn this token");
        delete _owner[tokenId];
        delete _tokenURI[tokenId];
        delete _merkleRoot[tokenId];
        delete _zkProof[tokenId];
        delete _token[tokenId];

        emit Burn(msg.sender, tokenId);
    }

    // get sbt data    
    function getMerkleRoot(uint256 tokenId) public view returns (string memory) {
        return _merkleRoot[tokenId];
    }
    function getZkProof(uint256 tokenId) public view returns (string memory) {
        return _zkProof[tokenId];
    }
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURI[tokenId];
    }

    // admin functions
    function editAdmin(address admin, bool isAdmin) public {
        require(_isAdmin[msg.sender], "You are not allowed to edit admins");
        _isAdmin[admin] = isAdmin;
    }
    function editBurner(address burner, bool isBurner) public {
        require(_isAdmin[msg.sender], "You are not allowed to edit burners");
        _isBurner[burner] = isBurner;
    }

}