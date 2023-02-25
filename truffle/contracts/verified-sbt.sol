// license: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract verified_sbt is ERC721 {

    mapping (address => bool) private _isMinter; // can mint tokens
    mapping (address => bool) private _isBurner; // can burn tokens even if they are not the owner
    mapping (address => bool) private _isAdmin; // admin can add and delete admins, set and unset minters and burners


    mapping (uint256 => address) private _owner; // link the sbt to a certain owner
    mapping (uint256 => address) private _token; // link the sbt to a certain token

    mapping (uint256 => string) private _tokenURI; // uri where we can get the addresses used to generate the proof
    mapping (uint256 => string) private _merkleRoot; // merkle root of the addresses (to ensure that the addresses have not been modified)
    mapping (uint256 => string) private _zkProof; // zk proof generated in the frontend (not verified yet)

    mapping (uint256 => uint256) private _timestamp; // timestamp of the minting of the proof


    uint256 private _tokenId;
    string private _name;
    string private _symbol;

    event Mint(address indexed owner, uint256 indexed tokenId);
    event Burn(address indexed owner, uint256 indexed tokenId);

    constructor(string memory name_, string memory symbol_, address verifier_) ERC721(name_, symbol_){
        _tokenId = 0;
        _name = name_;
        _symbol = symbol_;

        // verifier can mint and burn
        _isMinter[verifier_] = true;
        _isBurner[verifier_] = true;

        // contract creator has all the rights
        _isAdmin[msg.sender] = true;
        _isBurner[msg.sender] = true;
        _isMinter[msg.sender] = true;
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
    * @param zkProof is the zk proof generated in the frontend (which has been verified by the verifier)
    * mint a new sbt
    */
    function mint(address receiver, address token, string memory tokenURI, string memory merkleRoot, string memory zkProof) public {
        require(_isMinter[msg.sender], "You are not a minter");

        _owner[_tokenId] = receiver;
        _token[_tokenId] = token;
        _tokenURI[_tokenId] = tokenURI;
        _merkleRoot[_tokenId] = merkleRoot;
        _zkProof[_tokenId] = zkProof;
        _timestamp[_tokenId] = block.timestamp;
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
        delete _zkProof[tokenId];
        delete _timestamp[tokenId];
        delete _token[tokenId];

        emit Burn(msg.sender, tokenId);
    }

    // get sbt data    

    /**
    * @param tokenId is the id of the sbt
    * @return _merkleRoot associated to the sbt
    */
    function getMerkleRoot(uint256 tokenId) public view returns (string memory) {
        return _merkleRoot[tokenId];
    }
    /**
    * @param tokenId is the id of the sbt
    * @return _zkProof associated to the sbt
    */
    function getZkProof(uint256 tokenId) public view returns (string memory) {
        return _zkProof[tokenId];
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