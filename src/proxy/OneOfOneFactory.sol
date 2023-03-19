// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "src/proxy/OneOfOneProxy.sol";
import "src/proxy/OneOfOne.sol";

// Creates new instances of the 1:1 contract
// Takes the 1:1 implementation address as an argument and uses it to create a new 
// NFTCoreProxy contract, which is then initialized with a name and 
// returned as the new NFT address.

// deployment 295,559 gas
contract OneOfOneFactory {
    address immutable implementation;

    constructor (address _implementation) {
        implementation = _implementation;
    }

    // spits out address of your new 1:1 implementation with set name and symbol
    function createNFTContract(string memory name, string memory symbol) public returns (address newNFTAddress) {
        OneOfOneProxy newProxy = new OneOfOneProxy(implementation);
        newNFTAddress = payable(address(newProxy));
        OneOfOne(newNFTAddress).initialize(name, symbol);
    }
}