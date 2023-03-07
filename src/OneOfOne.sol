// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// The 1:1 implementation and the basic functionality
contract OneOfOne is Initializable {
    string name;

    function initialize (string memory _name) public initializer {
    name = _name;
    }

    function getMetaData() external view returns (string memory) {
    return name;
    }
}