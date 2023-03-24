// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {Test} from "lib/forge-std/src/Test.sol";

import {MinimalProxy} from "src/examples/MinimalProxy.sol";

// get gas cost for test factory deployment

contract MinimalProxyTest is Test {
    MinimalProxy public minimal;

    function setUp() public {
        minimal = new MinimalProxy();
    }

    function testSetUp() public {
        minimal.setUp();
    }
}
