// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {Test} from "lib/forge-std/src/Test.sol";

import {OneOfOneFactory} from "src/proxy/OneOfOneFactory.sol";
import {OneOfOne} from "src/proxy/OneOfOne.sol";

// get gas cost for test factory deployment

contract OneOfOneFactoryTest is Test {
    OneOfOne public one;
    OneOfOneFactory public factory;

    function setUp() public {
        one = new OneOfOne();
        factory = new OneOfOneFactory(address(one));
    }

    function testCreateNFTContract() public {
        factory.createNFTContract("Test", "TEST");
    }
}
