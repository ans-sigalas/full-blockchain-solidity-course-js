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
// Check Solidity Documentation for an extensive list of types: https://docs.soliditylang.org/en/latest/types.html

    uint256 favoriteNumber; // If you just say uint256 favoriteNumber; without giving a value, it will have the default value which, in Solidity, is 0.
    // By changing the favoriteNumber visibility to "public" like "uint256 public favoriteNumber;" we can actually see the variable once compiled.

    struct People { // This way we created a new type called "People", just like uint256 or string.
        uint256 favoriteNumber;
        string name;
    }

    People[] public people; // [] mean that People is an array.  
    // An array is a data structure that holds a list of other types. It is a way to store a list or a sequence of objects.
    // [] <- This array is known as a dynamic array because the size of the array is not given.
    // If we were to give it a value of [3] that mist that the list could only contain 3 values.
    // Because [] has no value, that means that this array can grow and shrink as we add or abstract more data to it.

    // Now what if we know someone's name but we don't know their favorite number?
    // One way would be to individually look through the whole array to find their favorite number; but that would be time consuming.
    // Another data structure that we can use to access this information is called "mapping".
    // Mapping is a data structure where a key is "mapped" to a single value.
    // An easy way to think of it is as a dictionary.
    mapping(string => uint256) public nameToFavoriteNumber;
    // This way, we now have a dictionary where every single name is going to map to a specific number.

    function store(uint256 _favoriteNumber) public { 
        // store: function that changes the number to some new value. The value will change to whatever value we pass threw it.
        // In this case we are allowing our store function to take a variable of type uint256 called _favoriteNumber, making the function public.
        favoriteNumber = _favoriteNumber; // This way we are setting favoriteNumber value to whatever _favoriteNumber variable we have passed.
    }

    // "Functions" or "Methods" are self-contained modules that will execute some specifit set of instructions, when we call them.
    // Functions can be identified by the keyword "function".
    // Functions and variables can have one of four Function Visibility Identifiers:
    // public: Visible externally and internally, meaning that anybody who interacts with this contract or sees this contract can see what's stored in this function.
    // private: Only visible in the current contract.
    // external: Only visible externally, meaning somebody outside this contract can call this function.
    // internal: Only visible internally, meaning that only this contract and its children contract can read this function.
    // When we don't give a visibility specifier to our function, then it automatically gets deployed as internal.
  
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }
    // There are two keywords in Solidity that notate a function that doesn't actually need to spend gas to run.
    // Those keywords are "view" and "pure".
    // view: Means that we are just going to read the state of this contract
    // Of note: If a retrieve function like "view" or "pure" are called within a function that costs money, they as well will cost money, because they are reading from the blockchain.

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber; // Serves as a capability to the addPerson function.
    }
    // People is capitalised and because of that we know it is refering to the struct "People" and not the array "people".
    // people.push <- Push is the equivalent of adding.


}

// NOTES On Solidity Memory, Storage, & Calldata

// There are six places that you can store data is Solidity:
// 1. Stack
// 2. Memory
// 3. Storage
// 4. Calldata
// 5. Code
// 6. Logs
// (Of note: Even though there are six places where we can access and store information, we cannot say a variable is stack, code, or logs. We can only say memory, storage, or calldata.

// In this instance we are going to mainly focus on explaining calldata, memory and storage.
// Calldata and memory mean that the data is only going to exist temporarily.
// Storage variables exist event outside of just the function executing.
// Calldata is temporary variables that cannot be modified.
// Memory is temporary variables that can be modified.
// Storage is permanent variables that can be modified.

// The reason we are using memory next to string but not next to uint256, is because solidity knows that the uint256 will be stored in memory.
// On the other hand, a string is actually an array of bytes. And since string is an array, we need to add "memory" to it, because we need to tell Solidity the data location of arrays, structs, or mappings.



// Add a layout to README file explaining the process of making the smart contract work.
// i.e. 1. Open Remix IDE at www....com
//      2. Compile the file
//      3. etc.
