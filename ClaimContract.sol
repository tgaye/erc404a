// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ClaimContract is Ownable {
    IERC20 public token;
    bytes32 public rootHash;
    mapping(address => bool) public claimed;

    constructor(address _token) {
        token = IERC20(_token);
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

    function claim(
        bytes32[] calldata proof
    ) public isWhiteListedAddress(proof) {
        require(!claimed[msg.sender], "Tokens already claimed");
        uint256 amount = 100 * 10 ** 18;
        require(
            token.balanceOf(address(this)) >= amount,
            "Not enough tokens in contract"
        );
        token.transfer(msg.sender, amount);
        claimed[msg.sender] = true;
    }

    function withdraw() public onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");
        token.transfer(owner(), balance);
    }

    function updateHash(bytes32 _hash) public onlyOwner {
        rootHash = _hash;
    }
}
