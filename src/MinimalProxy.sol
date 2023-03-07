// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "src/OneOfOne.sol";

// MinimalProxy contract sets up an instance of NFTCore and NFTCoreBuilder.
// testProxy() creates a new NFT contract using createNFTContract() 
// function of NFTCoreBuilder contract, and calls the getMetaData() from NFTCore Contract.
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