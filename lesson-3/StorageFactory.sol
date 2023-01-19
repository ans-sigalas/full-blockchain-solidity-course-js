// SPDX-License-Identifier: MIT

// We can have a contract deploy other contracts for us and we can have this contract interact with other contracts.
// Contracts interacting with each other is an essential part of working with Solidity and smart contracts.
// The ability for contracts to seamlessly interact with each other is what is known as "composability".

pragma solidity 0.8.8;

import "./SimpleStorage.sol"; // A way to import a different contract in our code.

contract StorageFactory {

 // SimpleStorage public simpleStorage; // This is a global variable. If we were to leave it like that, every time we call it, it replaces whatever is in our public simpleStorage variable.
    SimpleStorage[] public simpleStorageArray; // A way to keep a running list of all our simpleStorage variables. We made it an array.

    function createSimpleStorageContract() public { // Function to create a SimpleStorage contract.
        SimpleStorage simpleStorage = new SimpleStorage(); // new: Solidity know we want to create a new contract. By using SimpleStorage in the beginning we are saving it as a memory variable.
        simpleStorageArray.push(simpleStorage); // add simpleStorage variable to our simpleStorageArray.
    }

    // With the above we can keep track of all of our simple storage deployments but we cannot interact with them yet.
    // On this example we want to be able to call the store function on all of our SimpleStorage.sol that we created, from our StorageFactory.
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public { // sfStore = Storage Factory store
        // In order to interact with a contract we are going to need the following two.
        // Contract Address
        // Contract ABI - Application Binary Interface | The ABI will tell our code exactly how it can interact with the contract.
        // SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageIndex]); // Variable named simpleStorage of type SimpleStorage is going to be equal to a SimpleStorage object. 
        // If instead of the SimpleStorage[] we had address[], we would have to use the abovementioned line of code.
        // Instead of creating a new contract like we did before, instead we are going to get the address of the SimpleStorage object in the brackets, which we can get from our array.
        // The [] notation is how you access different elements of arrays.
        // Since SimpleStorage[] is an array of Simple Storage contracts we can just access that simple storage contract using the index.
 //       SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex]; // Now we are saving the contract object at an index _simpleStorageIndex to our simpleStorage variable.
        // The simpleStorageArray is keeping track of the addresses for us and it automatically comes with the ABIs.
 //       simpleStorage.store(_simpleStorageNumber); // Calling the store function on our simpleStorage contract. We are storing the _simpleStorageNumber to it.
        // If we were to deploy it without the sfGet function, we wouldn't be able to read the store function.
        // We can make the sfStore function even simpler by changing lines 32 & 34 to the following:
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    // Create another function call sfGet that can read from the SimpleStorage contract from the StorageFactory.
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
 //       SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
 //       return simpleStorage.retrieve();
        // We can make the sfGet function even simpler by changing lines 42 & 43 to the following:
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}
