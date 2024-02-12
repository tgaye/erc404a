const keccak256 = require("keccak256");
const { default: MerkleTree } = require("merkletreejs");
const fs = require("fs");

const address = [

];

let data = [];


// This function creates a merkle tree from the provided address variable, printing the root hash.
function createTree(){
    //  Hashing All Leaf Individual
    const leaves = address.map((leaf) => keccak256(leaf));
    
    // Constructing Merkle Tree
    const tree = new MerkleTree(leaves, keccak256, {
      sortPairs: true,
    });
    
    //  Utility Function to Convert From Buffer to Hex
    const buf2Hex = (x) => "0x" + x.toString("hex");
    
    // Get Root of Merkle Tree
    console.log(`Here is Root Hash: ${buf2Hex(tree.getRoot())}`);
}



// This function loops through the whitelised addresses and creates the proof used to verify their claim
// if you had a frontend you would allow the user to sign in then do these operation on their singular wallet.
// FLOW: Wallet sign in -> capture wallet address -> create proof -> user creates transaction sending newly created proof as a param -> verify proof on chain.
function createProofs() {
    // Pushing all the proof and leaf in data array
    address.forEach((address) => {
      const leaf = keccak256(address);
    
      const proof = tree.getProof(leaf);
    
      let tempData = [];
    
      proof.map((x) => tempData.push(buf2Hex(x.data)));
    
      data.push({
        address: address,
        leaf: buf2Hex(leaf),
        proof: tempData,
      });
    });
    
    // Create WhiteList Object to write JSON file
    let whiteList = {
      whiteList: data,
    };
    
    //  Stringify whiteList object and formating
    const metadata = JSON.stringify(whiteList, null, 2);
    
    // Write whiteList.json file in root dir
    fs.writeFile(`whiteList.json`, metadata, (err) => {
      if (err) {
        throw err;
      }
    });
}

createTree()
createProofs()