const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

async function main() {
  // We are setting this script up to run our encrypt key one time and then remove our private key from anywhere in our workspace so that there is nowhere in plain text.
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY); // Create a new wallet but a little bit different than deploy.js
  const encryptedJsonKey = await wallet.encrypt(
    process.env.PRIVATE_KEY_PASSWORD,
    process.env.PRIVATE_KEY
  );
  // This encrypt function is gonna return an encrypted JSON key that we can store locally and that we can only decrypt it by using our password.
  // It takes two parameters: A private key password and a private key.

  console.log(encryptedJsonKey); // To run it we run $node encryptKey.js on terminal.
  fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey); // To save the encrypted key. We are creating a new file called encryptedKey and we are passing it the encryptedJsonKey we will make.
  // Once we run it, we add the newly created .encryptedKey.json to our .gitignore and we delete our PRIVATE_KEY and PRIVATE_KEY_PASSWORD from our .env
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
