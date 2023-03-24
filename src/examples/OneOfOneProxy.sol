// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "lib/openzeppelin-contracts/contracts/proxy/Proxy.sol";
import "lib/forge-std/src/console.sol";
import "src/OneOfOne.sol";

// Example contract that shows how to upgrade/build off of
// the original 1:1 implementation contract without affecting 
// the contract address or ABI used by clients
// It points to the original 1:1 implementation contract
// notice functions override original/master 1:1 implementation

contract OneOfOneProxy is Proxy{
    address immutable _nftImplementation;

    constructor (address nftImplementation){
        _nftImplementation = nftImplementation;
    }

    // overrides prev 1:1 implementation located in 1:1 builder
    function _implementation() internal view override returns (address) {
    return _nftImplementation;
    }

    // created own fallback implementation
    function _beforeFallback() internal virtual override {
    console.log("fallback");
    }
}