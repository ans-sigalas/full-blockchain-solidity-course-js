// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

// We import this contract using the NPM address which can be found here: https://www.npmjs.com/package/@chainlink/contracts
// Which takes the contract from the github repository of chainlink here: https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // Originally part of the contract but now pasted onto the PriceConverter.sol library.
// The above contract is what's called an "Interface" which will give us the ABI. 
// The ABI is just a list of different functions included on this contract that we can use on our contract.

import "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256; // We tell the FundMe contract what are we using the PriceConverter library for.

    uint256 public minimumUsd = 50 * 1e18; // 50 and 18 decimal places

    // Because we want to keep track of all the people that sent us money, we need to create some data structures.
    address[] public funders; // Array of addresses called funders to add all the funders that send money to us.

    mapping(address => uint256) public addressToAmountFunded; // Mapping of addresses and how much money they actually sent.

    function fund() public payable { // This function is for people to send money to.
        // Just like wallet can hold funds, contract addresses can hold funds as well
        require(msg.value.getConversionRate() >= minimumUsd, "You need to send at least 1 Eth!"); 
                                    // We are not passing a variable inside our (), even though on our library, the getConversionRate function is expecting a uint256.
                                    // The reason is that the msg.value is considered the first parameter for any of these library functions.
                                    // If we wanted another variable inside our getConversionRate library function e.g. getConversionRate(uint256 ethAmount, uint256 somethingElse), then we should have passed something inside the () e.g. (123).
        // BEFORE LIBRARY: require(getConversionRate(msg.value) >= minimumUsd, "You need to send at least 1 Eth!");  // To get how much value someome is sending we use msg.value. 
                                    // To ask for a specific amount we use require.
                                    // require(msg.value >= 1e18, "You need to send at least 1 Eth!");
                                    // 1e18 == 1 * 10 ** 18 == 1000000000000000000 (**=raised to) - 1e18 Wei is equal to 1 Eth
                                    // The above statement means "If the require is not met then revert to this message".
                                    // Reverting means that undos any action that happened and sends the REMAINING gas back.
                                    // On msg.value the value is in terms of Ethereum. In order to convert it to usd we need to use an Oracle.
                                    // He had to add the function getConversionRate to make sure we send enough msg.value.
        funders.push(msg.sender);   // Any time someone sends money and it goes through, we add the funder on the list.
                                    // msg.sender is the address of whoever called the fund function in this case.
                                    // Like msg.value, msg.sender is an always available global keyword.
        addressToAmountFunded[msg.sender] = msg.value; // Add to mapping.
    } 

/*  // In order to get the price of the Layer 1 blockchain that we are working with (in this case is Ethereum).
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

    function getVersion() public view returns (uint256) { // To show us the version of the priceFeed
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) { 
        // With this function we are going to get a parameter of uint256 named ethAmount which is gonna return a uint256.
        // Which means we are going to pass it an ethAmount as uint256 and it is going to return a USD amount as uint256.
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // Because both ethPrice and ethAmount have each 18 zeros, we need to divide by 1e18. Otherwise, we are going to end up with 36 zeros.
        return ethAmountInUsd;

    }

    NOTE: Everything inside the / * * / comment was originally part of this contract before we created the PriceConverter.sol library.
*/
    function withdraw() public { // for the owner of the contract to be able to withdraw the fudns.
        // Since we are going to be withdrawing all the funds out of this contract, we would need to reset our funders Array and our addressToAmountFunded.
        // To do that we will be using something called "for loop".
        // A for loop is a way to loop through some type of index object or loop through some range of numbers or just do a task a certain amount of times, repeating.
        // The for keyword initiates a loop. Then we define how we want the loop to run. The formula is: (Starting index; Ending index; Step amount).
        // For example (0; 10; 1) we start with index 0, we go to 10 and we go up 1 at a time.
        // Our starting index would be called funderIndex and it's gonna be equal to 0.
        // We are going to end with the length of our funders array, since we wanna loop through all our funders.
        // As a step, every time the loop finishes, we are going to increase the funderIndex by 1.
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){ // funderIndex++ means funderIndex = funderIndex + 1
            address funder = funders[funderIndex]; // To access the first (0) element of our funders object we gonna say funders[funderIndex] and this is gonna return an address for us to use, which we are putting inside the funder object.
            addressToAmountFunded[funder] = 0; // Use funder to reset our mapping and our funded money back to zero.
        }

        funders = new address[](0); // Reset the funders array by creating a new address array with 0 objects in it.

        /* To send Ether or any native blockhain currency, there are actually three different ways to do it.
         * Transfer: msg.sender.transfer(address(this).balance); The "this" keyword refers to this whole contract.
         *           That way we can get the native blockchain currency or the Ethereum currency balance of this address.
         *           Only thing we need to do is to typecast msg.sender from an address type to a payable type.
         *           We can do this by doing the following: payable(msg.sender).tranfer(address(this).balance;
         *           msg.sender = is of type address
         *           payable(msg.sender) = is of type payable address
         *           In Solidity, in order to send the native blockchain token like Ethereum, you can only work with payable addresses.
         *           The problem with this is that it has a cap transaction cost of 2300 gas and if it fails it returns an error and the transaction fails.
         * Send:     Send on the other hand will not error. Instead it will return a boolean of whether or not it was successful.
         *           payable(msg.sender).send(address(this).balance; <- We don't want to finish our call here. If this were to fail, the contract wouldn't revert the transaction.
         *           So instead we want to do: bool sendSuccess = payable(msg.sender).tranfer(address(this).balance;
         *                                     require(sendSucess, "Send failed");
         *           This way, if this fails, we will still revert by adding our require statement.
         * Call:     Call is going to be one of the first lower level commands that we actually use in our Solidity code.
         *           This call function is actually very powerful as it can be used to call virtually any function in all of Ethereum, even without the API.
         *           payable(msg.sender).call("");
         *           Inside the call(...) is where we will put any function information that we want to call on some other contract.
         *           In this case we don't want to call a function so we are going to leave this blank. We can show we are leaving it blank but putting "".
         *           We instead want to use this as a transaction.
         *           We can do that by adding the following: payable(msg.sender).call{value: address(this).balance}("");
         *           This call function returns two variables and when the function returns two variables, we can show that by placing them inside brackets on the left hand side.
         *           (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
         *           The two variables are going to be a boolean that we are going to call callSuccess and also a bytes object called dataReturned.
         *           Since call is actually allowing us to call different functions, if that function returns some data or returns a value, we are going to save that in the dataReturned variable.
         *           It also returns callSuccess, where if the function was successfully call this would be true and if not, this would be false.
         *           Since bytes objects are arrays, data returned needs to be in memory.
         *           In the case of our contract, since we are not calling any functions we will leave the second variable empty but with a comma, to show that we don't need a second variable: 
         *           (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
         *           require(callSuccess, "Call failed");
         *           Similarly to the send function, we have to have a require statement so if it fails, it can be reverted.
         *           As a general rule for now, call is the recommended way to actually send and receive Ethereum or any blockchain native token.
         *           Call has no gas cap.
        */
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

}
