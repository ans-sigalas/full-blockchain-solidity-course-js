/*  General notes
    If you want to deploy the js file you can go to your terminal and write: node <filename.js> and press enter. This tells the terminal that you want to run the js file using Node.js.
    In order to state a variable we can use let variable = 5; which is similar to Solidity's uint256 variable = 5; . In JavaScript we use let, var or const .
    To print the variable you can do console.log(variable);
    Of note: In JavaScript it's optional on whether or not you want to have semicolons at the end of the syntax ";"
    A good way to run variables is to wrap then in functions. You can do that by using for example: function name(){ ... }
    If you try to deploy it using the terminal nothing will happen. This is because you need a line to call the main function. You can do that by (in this instance) adding name();

    synchronous and asynchronous programming:
    So far everything we have done so far has been synchronous as Solidity is a synchronous programming language.
    Synchronous means it goes one line after another.
    On the other hand, JavaScript is an asynchronous meaning that we can have code running at the same time.
    In other words, it is a way for us to do stuff without waiting for other things to finish.
    A good example would be cooking. In a synchronous environment you cannot cook two dishes at once whereas in an asynchronous environment you can.
    In order to make a function into an asynchronous function we have to add the keyword async in front of the function. For example: async function name(){ ... }
    By using the async keyword, we get access to another keyword that we can use inside our function called "await".
    Await tells the code to wait for the process defined with the await keyword to finish and then do something else.
    You can include functions inside a function that you can define separately. If you use the keyword await next to a function, then when you define it you have to say you wait for a Promise.
    Example:
    async function setupMovieNight() {
        await cookPopcorn();
        startMovie();
    }

    function cookPopcorn() {
        return Promise(Some Code Here);
    }

    The promise that we are asking for to be executed before we continue with our code, can either be: Pending, Fulfilled or Rejected.

*/

/*  Notes for deploy.js
    With this file we are trying to replicate whatever was happening inside Remix IDE.
    If we want to compile the contract SimpleStorage we need to write the following on the terminal, where the yarn is installed.
    $ yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o . SimpleStorage.sol
    Because we don't want to write all these commands every time we want to compile we will create a script on the package.json file (Check package.json file for format)
    After that you can go to the terminal and run the $ yarn compile command.
*/

/*  Notes about Ethers
    If we visit Ethereum JSON-RPC Specification https://playground.open-rpc.org/?schemaUrl=https://raw.githubusercontent.com/ethereum/execution-apis/assembled-spec/openrpc.json&uiSchema%5BappBar%5D%5Bui:splitView%5D=false&uiSchema%5BappBar%5D%5Bui:input%5D=false&uiSchema%5BappBar%5D%5Bui:examplesDropdown%5D=false
    We can actually see different calls we can make directly to our node to get different information.
    We can make these API calls directly ourselves using an API End-Point like Axios or Fetch.
    However we are going to use a wrapper to interact with our node like Ethers.js
    Ethers.js is one of the most popular JavaScript based tooling kits that allows us to interact with different blockchains and has all these wrappers that make all these API calls with Ethereum and other EVM compatible blockchains.
    Web3.js is another popular package that does the same thing.
    The reason why we are using Ethers is that it is the main tool that powers the hardhat environment.
    To install it we can do $ yarn add ethers
*/

// Import dependencies and external packages
const ethers = require("ethers"); // const similar to let. const makes it so ethers variable cannot be changed. require is a function to import ethers package
const fs = require("fs-extra"); // To install package we need to run $ yarn add fs-extra
require("dotenv").config(); // To call the dotenv tool.

async function main() {
  // http://127.0.0.1:7545 <- Ganache RPC Server

  // Below is our connection to the blockchain
  const provider = new ethers.providers.JsonRpcProvider(
    // "http://127.0.0.1:7545" This is not actually something that we need to secure, however, maybe we would like to use an API key or a certain endpoint that only we want to have access to.
    process.env.RPC_URL
  ); // We say that we are going to connect to the url inside the bracket.

  //Below is our wallet
  const wallet = new ethers.Wallet( // Import new wallet from ganache
    // "b26801e16b664597d257e9eb5813b5da3c1521c618850be463cea3de692c3b9f", // private key | Of note: Pasting your private key directly into your code is a no-no. We will learn to avoid it in the future.
    process.env.PRIVATE_KEY,
    provider
  );
  // If we were to push the online, people would be able to see our private key.
  // One way to avoid that is by using a .env file or an "Environment Variable Fine".
  // We can set this variables on our terminal but for now we are going to set them in a .env file.
  // .env is a file where we will store sensitive information and we are never going to share with anybody.
  // This .env file will choose variables of our choosing into the environment of our code.
  // Of note regarding the .env file: Some tools might need a "0x" in front of our private key, but ethers and hardhat don't.
  // To be able to grab our private key from the .env file and put it on our deploy.js file, we have to download a tool called dotenv.
  // We do that by running $yarn add dotenv

  // In order to deploy our contract we are going to need the ABI and the BIN codes of the contract.
  // For that, we need to read from the two files that we created previously.
  // To do that, we need to use a package called "fs".
  // Below we call the ABI.
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");

  // Below we call the BIN.
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );

  // Now that we have the BIN and the ABI we can create something called a contract factory.
  // In ethers a contract factory is just an object that you can use to deploy contracts.
  // Below we call the contract factory object.
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  // We passed the abi so that our code knows how to interact with contract.
  // We passed the binary because this is the main compiled code in our wallet so that we have a private key we can use to sign while deploying this contract.

  console.log("Deploying, please wait...");

  // We can now deploy this contract with ethers with the following:
  const contract = await contractFactory.deploy(); // This tells our code to stop here and wait for contract to be deployed.
  // If we want to add some specifics about our contract deployment like gas price, gas limit, etc. we have to use the override function which can be found within our "deploy" definition.
  // We can find the contractFactory.deploy(); override by pressing CTRL + click on the "deploy" function.
  // This will take us into the function so we can see anything about this function (e.g., how it's defined, etc. )
  // We can add overrides in our deploy function by doing the following: const contract = await contractFactory.deploy({gasLimit:100000}); / gasLimit was an example
  // Another thing we can do is we can wait a certain amount of blocks to make sure that it will actually get attached to the chain.
  // We can do that by doing the following:
  await contract.deployTransaction.wait(1);
  // This way we specified that we want to wait 1 block for confirmation.
  // For that we have to run the following:
  // console.log("Here is the deployment transaction: ");
  // console.log(contract.deployTransaction);
  // console.log("Here is the transaction receipt: ");
  // console.log(transactionReceipt);
  // console.log(contract);

  const currentFavoriteNumber = await contract.retrieve(); // To retrieve our favorite number.
  // console.log("Here is the current favorite number: ");
  // console.log(currentFavoriteNumber.toString());
  // Instead of the above, we can make it more syntactical correct by using something called string interpolation, to interpolate our string with variables.
  // Typically for JavaScript strings we use double quotes "" but if we want to include variables with strings we can use backticks `` instead (located next to button 1).
  // ${} means that it includes a function.
  console.log(`Current Favorite Number: ${currentFavoriteNumber.toString()}`);
  const transactionResponse = await contract.store("7");
  const transactionReceipt = await transactionResponse.wait(1);
  const updatedFavoriteNumber = await contract.retrieve();
  console.log(`Updated Favorite Number: ${updatedFavoriteNumber}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
