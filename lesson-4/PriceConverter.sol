// SPDX-License-Identifier: MIT

// This contract is going to be a library that we are going to attach to a uint256.
// Libraries are similar to contracts but you can't declare any state variable and you can't send ether.
// All the functions in a library are internal.
// The original functions getPrice, getVersion and getConversionRate have been copied from the FundMe.sol contract, where you can find explanations on what they are.

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.8.8;

library PriceConverter{

    // All the functions inside of our library need to be internal.
    // We are going to make this PriceConverter, different functions we can call on a uint256.

    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) { 
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;

    }
}
