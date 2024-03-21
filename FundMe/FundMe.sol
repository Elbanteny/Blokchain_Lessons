// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using  PriceConverter for uint256;

    // constant and immutable can save more gas
    // Could we make this constant?  /* hint: no! We should make it immutable! */
   uint256 public constant MINIMUM_USD = 1e18; // = (5eth)

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund () public payable  {
        // allow user to send $
        // Have minimum $ sent
        // how to send eth to this contract
        require (msg.value.getConversationRate() >= MINIMUM_USD, "Not Enough Eth!"); // 1e18 = 1 eth 
        funders.push(msg.sender);
        addressToAmountFunded [msg.sender] += msg.value;

        // revert = undo any actions that have done, and send the reamaining gas back
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function withdraw () public onlyOwner {
        
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }

        // reset array  
        funders = new address[](0);
        //withdraw fund

         // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner(){
        // custom error can save more gas
        if (msg.sender != i_owner) revert NotOwner();
        // require(msg.sender == i_owner, "Sender is not Owner!");
        _; //execute after the function running
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
    
}