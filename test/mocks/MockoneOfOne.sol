// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {OneOfOne} from "src/proxy/OneOfOne.sol";

contract MockOneOfOne is OneOfOne {
  

    function tokenURI(uint256) public pure virtual returns (string memory) {}

    function mint(address to) public virtual {
        _mint(to);
    }

    function burn() public virtual {
        _burn();
    }

    function safeMint(address to) public virtual {
        _safeMint(to);
    }

    function safeMint(
        address to,
        bytes memory data
    ) public virtual {
        _safeMint(to, data);
    }
}