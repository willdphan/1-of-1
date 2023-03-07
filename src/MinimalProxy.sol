// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "src/OneOfOne.sol";
import "src/OneOfOneBuilder.sol";

// MinimalProxy contract sets up an instance of OneOfOne and OneOfOneBuilder
// testProxy() creates a new NFT contract using createNFTContract() 
// function of OneOfOneBuilder contract, and calls the getMetaData() from OneOfOne Contract.
contract MinimalProxy {
    OneOfOne oneOfOne;
    OneOfOneBuilder builder;

    function setUp() public {
        // the 1:1 implementation
        oneOfOne = new OneOfOne();
        // deploys 1:1 implementation duplicator
        builder = new OneOfOneBuilder(address(oneOfOne));
    }

    function testProxy() external {
        // deploys 1:1 implementation with Test as the Name
        address newNFTAddress = builder.createNFTContract("Test");

        (bool success, bytes memory data) = address (newNFTAddress).call(abi.encodeWithSignature("getMetaData()"));

        console.log(string(data));
    }
}