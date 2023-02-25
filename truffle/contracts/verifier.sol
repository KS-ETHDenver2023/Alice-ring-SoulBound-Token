// license: MIT

pragma solidity ^0.8.17;

import "./ISBT.sol";
import "./ITempSBT.sol";

contract verifier {

    ITempSBT _temp_sbt;
    ISBT _sbt;

    constructor(address temp_sbt, address sbt) {
        _sbt = ISBT(sbt);
        _temp_sbt = ITempSBT(temp_sbt);

    }


    function verifyProof(uint256 temp_sbt_id, string memory zkProof) public returns (bool) {
        // a coder avec le verifier de zokrates
        return true;
    }

    function sbtVerification(uint256 temp_sbt_id, address[] memory addresses) public {
        
        // get data from temp_sbt
        bytes32 merkleRoot = _temp_sbt.getMerkleRoot(temp_sbt_id);
        string memory zkProof = _temp_sbt.getZkProof(temp_sbt_id);
        string memory tokenURI = _temp_sbt.getTokenURI(temp_sbt_id);
        address tokenAddress = _temp_sbt.getTokenAddress(temp_sbt_id);

        require(verifyProof(temp_sbt_id, zkProof), "Proof is not valid");
        require(verifyRoot(merkleRoot, addresses), "Merkle root does not correspond to the addresses");

        // burn temp_sbt
        _temp_sbt.burn(temp_sbt_id);

        // mint sbt
        _sbt.mint(msg.sender, tokenAddress, tokenURI, merkleRoot, zkProof);

    }


    // merkle tree functions

    // build root from a list of addresses
    function buildRoot(address[] memory addresses) public pure returns (bytes32) {
        bytes32[] memory leaves = new bytes32[](addresses.length);
        for (uint i = 0; i < addresses.length; i++) {
            leaves[i] = keccak256(abi.encodePacked(addresses[i]));
        }
        return buildRootFromLeaves(leaves);
    }

    // build root from a list of leaves
    function buildRootFromLeaves(bytes32[] memory leaves) private pure returns (bytes32) {
        if (leaves.length == 0) {
            return 0x0;
        }
        if (leaves.length == 1) {
            return leaves[0];
        }
        if (leaves.length % 2 == 1) {
            bytes32[] memory tmp = new bytes32[](leaves.length + 1);
            for (uint i = 0; i < leaves.length; i++) {
                tmp[i] = leaves[i];
            }
            tmp[leaves.length] = leaves[leaves.length - 1];
            leaves = tmp;
        }
        bytes32[] memory parents = new bytes32[](leaves.length / 2);
        for (uint i = 0; i < leaves.length; i += 2) {
            parents[i / 2] = keccak256(abi.encodePacked(leaves[i], leaves[i + 1]));
        }
        return buildRootFromLeaves(parents);
    }

    // check if a merkle root is valid
    function verifyRoot(bytes32 root, address[] memory addresses) public pure returns (bool) {
        return buildRoot(addresses) == root;
    }
    

    
}