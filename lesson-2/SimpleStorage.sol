// SPDX-License-Identifier: MIT
// On top of your code you always want to put what is called an SPDX-License-Identifier. 
// This is optional but some compilers will flag a warning that you don’t have it. 
// This is to make licensing and sharing code a lot easier.

pragma solidity 0.8.8; // ^0.8.8 or >=0.8.8 <0.9.0;
// pragma solidity and then the version of solidity that we want to use
// Every line of solidity that is completed needs to end with a semicolon “;” to let Solidity know it’s the end of the line.
// ← a way to add comments. Make sure you use comments to your advantage. Every time that you write a function or you learn something new, make sure you add a comment.
// ^ ← in that way we tell Solidity that any version of the one specified and above, will be ok to use for this contract.
// If we want to specify a range of versions we can use >=_._._ <_._._; That means “more or equal to… but less than…”..

contract SimpleStorage {
// contract ← This tells Solidity that the next lines of code are going to be a contract.
// “SimpleStorage” is the name that we decided to give to our contract.
// Then we add some “{ }”. Everything inside these curly brackets is going to be the contents for the contract named “SimpleStorage”.

// The Solidity language has many types (https://docs.soliditylang.org/en/latest/types.html) but the most commonly used ones are boolean, uint, int, address, bytes
// boolean: Defines some type of true-false.
//      bool hasFavoriteNumber = true;
// uint: Unsigned integer, which means is going to be a whole number that isn’t positive or negative. It’s just positive.
//      uint256 favoriteNumber = 5;
// You can also specify how many bits and bytes can be on your uint. For example you can say uint8 which is going to be 8 characters. The default is 256. If you don’t specify it, it will take it as being the default number.
// If uint is left blank then it automatically gets initialized as a zero because the default uint number for solidity is zero (0). 
// int: Integer, which is going to be a positive or negative whole number.
//      int256 favoriteInt = -5;
// For uint and int the lowest value you can have is 8 (e.g. uint8) and you can only go up by multiples of 8, until you reach 256.
// address: This is going to be an address (like the wallet address).
//      address myAddress = 0x8E0c31c374C6F4613aa6B631007488D38716D5FF;
// The reason we have all these types is to use them to define what different variables are. Variables are basically holders for different values. 
// If for example we create a variable called hasFavoriteNumber and we want to give it a boolean type then we should write: bool hasFavoriteNumber = true; Since boolean type can only be true or false, that means that our variable in this case, does have a favorite number.
// string: Another type is string. Strings represent words and you can represent them but putting them in quotations “ ”.
//      string favoriteNumberInText = "Five";
// bytes: We can also have bytes object or bytes32, representing how many bytes we want them to be. In our example, we called our object favoriteBytes and we set a value of "cat".
//      bytes32 favoriteBytes = "cat";
// Interestingly, strings are secretly just bytes objects but only for text.
// bytes32 is the maximum value the bytes can be.

// Continue from 2:17:21


}


