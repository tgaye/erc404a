//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404a/ERC404aMetadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract WIFU is ERC404aMetadata {
    string public baseTokenURI;
    bytes32 public rootHash;
    mapping(address => bool) public claimed;


    constructor(
        address _owner
    ) ERC404aMetadata("WIFU 404", "WIFU", 18, 200000, _owner, 100) {
        balanceOf[_owner] = 200000 * 10 ** 18;
    }

    function isValidProof(
        bytes32[] calldata proof,
        bytes32 leaf
    ) private view returns (bool) {
        return MerkleProof.verify(proof, rootHash, leaf);
    }

    modifier isWhiteListedAddress(bytes32[] calldata proof) {
        require(
            isValidProof(proof, keccak256(abi.encodePacked(msg.sender))),
            "Not WhiteListed Address"
        );
        _;
    }

    function claim(bytes32[] calldata proof) public isWhiteListedAddress(proof) {
        require(!claimed[msg.sender], "Tokens already claimed");
        require(balanceOf[address(this)] >= 15, "Not enough tokens in contract");
        _transfer(address(this), msg.sender, 15);
        claimed[msg.sender] = true;
    }

    function updateHash(bytes32 _hash) public onlyOwner {
        rootHash = _hash;
    }

    function setTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    function setNameSymbol(
        string memory _name,
        string memory _symbol
    ) public onlyOwner {
        _setNameSymbol(_name, _symbol);
    }

    /**
     * @dev Overrides the parent implementation in ERC404Metadata.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}
