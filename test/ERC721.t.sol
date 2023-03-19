// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import {MyToken} from "src/proxy/ERC721.sol";

import {Test} from "lib/forge-std/src/Test.sol";

contract ERC721DeploymentTest is Test {
    MyToken public token;

    function testSetUp() public {
        token = new MyToken();
    }
}
