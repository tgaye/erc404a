## The main token logic can be found in token.sol

If you replace the values in the constructor you can specify how many tokens you want for each ERC404 NFT.

In our example we have an NFT being minted for every 100 tokens,  with a total supply of 1,000,000 tokens.

Simply adjust these values to fit your collection.<br>

##YOU MUST THEN EDIT THE MATH FOUND IN ERC404A.SOL: <br>
        uint256 tokens_before = (balanceOf[to] / unit) / 100; <br>
        uint256 tokens_after = ((balanceOf[to] + amount) / unit) / 100; <br>
        uint256 tokens_from_before = (balanceOf[from] / unit) / 100; <br>
        uint256 tokens_from_after = ((balanceOf[from] - amount) / unit) / 100;<br>

Divide by the number of tokens you wish each NFT to have.
        

## Getting Started

To get started with this project, clone the repository and install the dependencies.

git clone https://github.com/tgaye/ERC404A.git
cd ERC404_AIRDROP
npm install

## Contract

The main contract in this project is [MerkleTreeWhiteList](). It has the following key features:

- [rootHash](): This is the root hash of the Merkle Tree. It is set in the constructor and can be updated by the contract owner using the [updateHash]() function.

- [updateHash](): This function allows the contract owner to update the [rootHash](). It uses the [onlyOwner]() modifier from the [Ownable]() contract to restrict access.

- [isValidProof](): This function verifies a Merkle proof against the current [rootHash]().

- [isWhiteListedAddress](): This is a modifier that checks if the sender's address is whitelisted by verifying a Merkle proof.


## MerkleTree.js

This JavaScript file is responsible for creating a Merkle Tree from a list of addresses and generating proofs for each address. It uses the merkletreejs and keccak256 libraries for these operations.
Key Functions

- createTree(): This function creates a Merkle Tree from the provided addresses, printing the root hash. It first hashes each address using keccak256 to create the leaves of the tree. It then constructs the Merkle Tree using merkletreejs and prints the root hash.

- createProofs(): This function generates a Merkle proof for each address in the list. It first hashes the address to get the corresponding leaf in the Merkle Tree. It then generates the proof using merkletreejs and stores the proof, the hashed address (leaf), and the original address in an object. This object is then added to the data array. Finally, it writes the data array to a JSON file named whiteList.json.
Usage

This file is meant to be run as a standalone script. It first calls createTree() to create the Merkle Tree and then createProofs() to generate the proofs. The output is a whiteList.json file containing the proofs for each address.
js

This will generate the whiteList.json file in the root directory.


## Dependencies

This project uses the following dependencies:

- @openzeppelin/contracts: For contract ownership and Merkle proof verification.
- [fs](): For file system operations.
- [keccak256](): For hashing.
- [merkletreejs](): For Merkle tree operations.

## Testing

Currently, there are no tests specified for this project. You can add your own in the [test]() directory and run them with npm test.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

## License

This project is licensed under the ISC license.
