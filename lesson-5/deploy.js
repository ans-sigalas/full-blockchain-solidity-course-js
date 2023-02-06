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

async function main() {
  // http://127.0.0.1:7545 <- Ganache RPC Server

  // Below is our connection to the blockchain
  const provider = new ethers.providers.JsonRpcProvider(
    "http://127.0.0.1:7545"
  ); // We say that we are going to connect to the url inside the bracket.

  //Below is our wallet
  const wallet = new ethers.Wallet( // Import new wallet from ganache
    "9897630a9443992fbe167de27b7536cd59a37b90b821018a5dd67e2a55a67f58", // private key | Of note: Pasting your private key directly into your code is a no-no. We will learn to avoid it in the future.
    provider
  );

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

  console.log(contract);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
