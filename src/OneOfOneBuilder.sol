// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// Creates new instances of the 1:1 contract
// Takes the 1:1 implementation address as an argument and uses it to create a new 
// NFTCoreProxy contract, which is then initialized with a name and 
// returned as the new NFT address.
contract OneOfOneBuilder {
    address immutable implementation;

    constructor (address _implementation) {
        implementation = _implementation;
    }


    function createNFTContract(string memory name) public returns (address newNFTAddress) {
        OneOfOneProxy newProxy = new OneOfOneProxy(implementation);
        newNFTAddress = payable(address(newProxy));
        OneOfOne(newNFTAddress).initialize(name);
    }
}