// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

// We import this contract using the NPM address which can be found here: https://www.npmjs.com/package/@chainlink/contracts
// Which takes the contract from the github repository of chainlink here: https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// The above contract is what's called an "Interface" which will give us the ABI. 
// The ABI is just a list of different functions included on this contract that we can use on our contract.


contract FundMe {

    uint256 public minimumUsd = 50;

    function fund() public payable { // This function is for people to send money to.
        // Just like wallet can hold funds, contract addresses can hold funds as well
        require(msg.value >= minimumUsd, "You need to send at least 1 Eth!");  // To get how much value someome is sending we use msg.value. 
                                    // To ask for a specific amount we use require.
                                    // require(msg.value >= 1e18, "You need to send at least 1 Eth!");
                                    // 1e18 == 1 * 10 ** 18 == 1000000000000000000 (**=raised to) - 1e18 Wei is equal to 1 Eth
                                    // The above statement means "If the require is not met then revert to this message".
                                    // Reverting means that undos any action that happened and sends the REMAINING gas back.
                                    // On msg.value the value is in terms of Ethereum. In order to convert it to usd we need to use an Oracle.
    } 

    // In order to get the price of the Layer 1 blockchain that we are working with (in this case is Ethereum).
    // In order to get the price we need to use the Chainlink Data Feeds.
    // Since this is an instance that we want to interact with a contract outside of our project, we are going to need two things:
    // ABI
    // Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // What we are doing is we are calling the function latestRoundData on our priceFeed.
        // The latestRoundData returns all the variables in the brackets.
        // Originally the brackets contained the following: (uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound)
        // Because we don't care about all these variables, we are going to delete the ones we don't need but keep the commas.
        // This int256 price will return the price of ETH in terms of USD.
        // It also returns the price of eth with 8 decimal places.
        // The problem is that our msg.value has 18 decimal places.
        // Because of that we have 2 different units and they don't match up.
        // To match them up we have to do the following.
        return uint256(price * 1e10); // 1**10 == 10000000000, which is 10 decimal places.
        // msg.value is a uint256 but the price is an int256. For that we have to convert the int256 to a uint256 through what is called "typecasting".
        // We can do that by adding unit256 next to price and wrap the type into brackets.
    }

    function getConversionRate() public {

    }

   // function withdraw(){

  //  } // for the owner of the contract to be able to withdraw the fudns.
  
  // Need to continue from 4:15:21



}
