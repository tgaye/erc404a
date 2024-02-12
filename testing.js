function transfer(from, to, amount, balanceOf, whitelist, unit) {
  let balanceBeforeSender = balanceOf[from];
  let balanceBeforeReceiver = balanceOf[to];
  balanceOf[from] -= amount;

  balanceOf[to] += amount;

  // Burn tokens from the sender if their balance goes below a multiple of 100

  let tokens_to_burn =
    Math.floor(balanceBeforeSender / 100) - Math.floor(balanceOf[from] / 100);
  for (let i = 0; i < tokens_to_burn; i++) {
    // _burn(from);
    console.log("burn", i);
  }

  // Mint tokens to the receiver for every 100 tokens they receive
  if (!whitelist[to]) {
    let tokens_before = Math.floor(balanceBeforeReceiver / 100);
    let tokens_after = Math.floor(balanceOf[to] / 100);
    console.log(tokens_before)
    console.log(tokens_after)
    if (tokens_after > tokens_before) {
      let tokens_to_mint = tokens_after - tokens_before;
      for (let i = 0; i < tokens_to_mint; i++) {
        // mint(to); // Assuming you have a mint function defined
        console.log("mint", i);
      }
    }
  }

  // Emit ERC20Transfer event
  // emitERC20Transfer(from, to, amount);
  return true;
}
// Define the initial state
let balanceOf = {
  Alice: 1000,
  Bob: 500,
  Owner: 0,
};

let whitelist = ["Owner"];
let taxPercentage = 2;
let unit = 1;

// Alice transfers 200 tokens to Bob
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);
transfer("Alice", "Bob", 10, balanceOf, taxPercentage, whitelist, unit);

// Print the final state
console.log(balanceOf);
