// SPDX-License-Identifier: MIT

/* Keywords: In Solidity there are two keywords that make it so that your variabless cannot be changed.
*       Constant: If you assign a variable once outside of a function and then never change it, you can add the keyword "constant" to save gas.
*                 Constant variables have a different naming convention and they typically they are all caps with underscores.
*      Immutable: Variables that we only set one time but outside of the line they got declared (e.g. owner) we can mark as "immutable".
*                 Immutable variables typically follow the naming convention of "i_".
* Another thing we can do to optimise our contract is by updating our requirements. Right now, with our require statement we have to store a message as a string array.
* Instead, we can create a custom error and then do an if statement where it is actually required.
*/
pragma solidity ^0.8.8;

import "https://github.com/ans-sigalas/full-blockchain-solidity-course-js/blob/main/lesson-4/PriceConverter.sol";

error NotOwner();
error NeedMoreUsd();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;
    
    address public immutable i_owner;
    
    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to send at least 50 USD!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // A += B is equivalent to A = A+B
    } 

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    
    modifier onlyOwner {
        //require(msg.sender == i_owner, "Sender is not the owner of this contract!");
        if(msg.sender != i_owner) { revert NotOwner(); } // != means it's not. This statement says if the msg.sender is not the i_owner then revert to NotOwner error.
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function?+
    // There is actually a way for when people send money to this contract directly or call a function that doesn't exist, for us to still trigger some code.
    // There are two special functions in Solidity:
    // receive():  https://docs.soliditylang.org/en/latest/contracts.html#receive-ether-function
    // fallback(): https://docs.soliditylang.org/en/latest/contracts.html#fallback-function

    receive() external payable {
        fund();
    }

    // receive() is a function but we don't have to add the function keyword for receive since Solidity knows that it is a special function.
    // Whenever we send Ethereum or make a transaction to this contract now, as long as there is no data associated with that transaction, this receive function will get triggered.

    fallback() external payable {
        fund();
    }

    // This way, if someone sends money straight to the contract, we trigger the fund function.

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //        /       \
    //   receive()?   fallback
    //      /  \
    //    yes   no
    //    /      \
    // receive()  fallback()
}
