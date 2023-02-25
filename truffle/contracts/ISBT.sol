pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ISBT is IERC721 {

    // get sbt data    

    /**
    * @param tokenId is the id of the sbt
    * @return _merkleRoot associated to the sbt
    */
    function getMerkleRoot(uint256 tokenId) external view returns (string memory);

    /**
    * @param tokenId is the id of the sbt
    * @return _zkProof associated to the sbt
    */
    function getZkProof(uint256 tokenId) external view returns (string memory);

    /**
    * @param tokenId is the id of the sbt
    * @return _tokenURI associated to the sbt
    */
    function getTokenURI(uint256 tokenId) external view returns (string memory);

    /**
    * @param tokenId is the id of the sbt
    * @return _timestamp associated to the sbt
    */
    function getTimestamp(uint256 tokenId) external view returns (uint256);

    // admin functions
    /**
    * @param admin is the address of the admin to add/remove
    * @param isAdmin is true if the admin is added, false if the admin is removed
    */
    function editAdmin(address admin, bool isAdmin) external;

    /**
    * @param minter is the address of the minter to add/remove
    * @param isMinter is true if the minter is added, false if the minter is removed
    */
    function editMinter(address minter, bool isMinter) external;

    /**
    * @param burner is the address of the burner to add/remove
    * @param isBurner is true if the burner is added, false if the burner is removed
    */
    function editBurner(address burner, bool isBurner) external;
}

