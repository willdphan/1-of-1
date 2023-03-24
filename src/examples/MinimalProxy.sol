// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "src/OneOfOne.sol";
import "src/OneOfOneFactory.sol";

// This is a test contract that shows workflow on Minimal Proxy Solution
// MinimalProxy contract sets up an instance of OneOfOne and OneOfOneBuilder
// testProxy() creates new NFT contract using createNFTContract() 
// OneOfOneFactory contract, calls the getMetaData() from OneOfOne Contract.

// deployment 1,865,609 gas
contract MinimalProxy {
    OneOfOne oneOfOne;
    OneOfOneFactory factory;

    // 1,638,869 gas
    function setUp() public {
        // the 1:1 implementation
        // 1,233,281 gas
        oneOfOne = new OneOfOne();
        // deploys 1:1 implementation duplicator
        // 295,559 gas
        factory = new OneOfOneFactory(address(oneOfOne));
    }

    // factory deploys new 1:1 implementation
    // 213,556 gas
    function testProxy() external {
        // creates 1:1 implementation with "Test" as the name and symbol
        // 206,180 gas to deploy new nft contract
        address newNFTAddress = factory.createNFTContract("Test", "TEST");

        // 1,084 gas
        (bool success, bytes memory data) = address (newNFTAddress).call(abi.encodeWithSignature("getMetaData()"));

        console.log(string(data));
    }
}