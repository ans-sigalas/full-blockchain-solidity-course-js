// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "https://github.com/ans-sigalas/full-blockchain-solidity-course-js/blob/main/lesson-4/PriceConverter.sol";

error NotOwner();
error YouNeedAtLeast50USD();
error CallFailed();

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
        if(msg.value.getConversionRate() <= MINIMUM_USD) { revert YouNeedAtLeast50USD(); }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        //require(callSuccess, "Call failed");
        if (!callSuccess) {
            revert CallFailed();
        }
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
