// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "./SimpleStorage.sol"; // We are making ExtraStorage.sol aware of the SimpleStorage.sol contract.

contract ExtraStorage is SimpleStorage { // is = This is something called inheritance and it's when we have a contract be a child contract of another contract. In other words, have exactly the same functionality as the parent contraact.
    // In our ExtraStorage contract we want the store function of the original SimpleStorage contract to +5 to any number that we give it.
    // In order to achieve this we need to do something that is called overriding.
    // For that we are going to use two keywords: virtual, override
    function store(uint256 _favoriteNumber) public override { // This function exists on the SimpleStorage.sol contract as well. For that reason we had to add the word override. Equally, we had to add the word virtual to the original function on the SimpleStorage.sol contract to allow it to be overrode.
    favoriteNumber = _favoriteNumber + 5;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public override {
        people.push(People(_favoriteNumber + 10, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber + 10;
    }
}
