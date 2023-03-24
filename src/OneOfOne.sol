// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "lib/openzeppelin-contracts/contracts/utils/Context.sol";
import "src/utils/Initializable.sol";
import "src/utils/OneOfOneReceiver.sol";

// 1:1 implementation/original/master implementation, 
// contract that all of the Minimal Proxies will derive 
// functionality from. only 1 mint is allowed with ID of 1. 
// Only the owner of 1:1 can burn

// deployment 1,233,281 gas
contract OneOfOne is Context, Initializable, OneOfOneTokenReceiver {
    
    /// EVENTS ///

    event Transfer(address indexed from, address indexed to);

    event Approval(address indexed owner, address indexed spender);

    event ApprovalForAll(address indexed operator, bool approved);

    /// METADATA STORAGE/LOGIC ///

    string public name;

    string public symbol;

    /// BALANCE/OWNER STORAGE ///

    address public _ownerOf;

    uint public _balanceOf;

   function balanceOf(address owner) public view returns (uint ownerBalance) {
        assembly {
            // require owner. if no owner, revert
            if iszero(owner) {
                revert(0x00, 0x00)
            }
            // if owner is same as owner in slot, load balance of 1
            if eq(owner, sload(_ownerOf.slot)) {
                ownerBalance := 1
            } 
        }
    }

    function ownerOf() public view virtual returns (address owner) {
        require((owner = _ownerOf) != address(0), "NOT_MINTED");
    }

    /// APPROVAL STORAGE ///

    // to prevent being minted twice
    bool private _minted;

    address public getApproved;

    mapping(address => bool) public isApprovedForAll;

    /// FUNCTION CONSTRUCTOR ///

    function initialize (string memory _name, string memory _symbol) public initializer {
        name = _name;
        symbol = _symbol;
    }

    /// LOGIC ///

    function approve(address spender) public virtual {
        address owner = _ownerOf;

        require(msg.sender == owner || isApprovedForAll[msg.sender], "NOT_AUTHORIZED");

        getApproved = spender;

        emit Approval(owner, spender);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[operator] = approved;

        emit ApprovalForAll(operator, approved);
    }

    function transferFrom(
        address from,
        address to
    ) public virtual {
        require(from == _ownerOf, "WRONG_FROM");

        require(to != address(0), "INVALID_RECIPIENT");

        require(
            msg.sender == from || isApprovedForAll[msg.sender] || msg.sender == getApproved,
            "NOT_AUTHORIZED"
        );

        _ownerOf = to;

        delete getApproved;

        emit Transfer(from, to);
    }

    function safeTransferFrom(
        address from,
        address to
    ) public virtual {
        transferFrom(from, to);

        require(
            to.code.length == 0 ||
             OneOfOneTokenReceiver(to).onOneOfOneReceived(msg.sender, from, "") ==
           OneOfOneTokenReceiver.onOneOfOneReceived.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        bytes calldata data
    ) public virtual {
        transferFrom(from, to);

        require(
            to.code.length == 0 ||
         OneOfOneTokenReceiver(to).onOneOfOneReceived(msg.sender, from, data) ==
                OneOfOneTokenReceiver.onOneOfOneReceived.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    /// ERC165 LOGIC ///

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    /// MINT/BURN LOGIC ///

    function _mint(address to) public virtual {
        require(to != address(0), "INVALID_RECIPIENT");
        // require that it hasn't been minted
        require(!_minted, "ALREADY_MINTED");

        // set minted to true
        _minted = true;

        _ownerOf = to;

        emit Transfer(address(0), to);
    }

    function _burn() public virtual {
        address owner = _ownerOf;

        require(owner != address(0), "NOT_MINTED");

        delete _ownerOf;

        delete getApproved;

        emit Transfer(owner, address(0));
    }

    /// INTERNAL SAFEMINT LOGIC ///

    function _safeMint(address to) internal virtual {
        _mint(to);

        require(
            to.code.length == 0 ||
              OneOfOneTokenReceiver(to).onOneOfOneReceived(msg.sender, address(0), "") ==
              OneOfOneTokenReceiver.onOneOfOneReceived.selector,
            "UNSAFE_RECIPIENT"
           
        );
    }

    function _safeMint(
        address to,
        bytes memory data
    ) internal virtual {
        _mint(to);

        require(
            to.code.length == 0 ||
                OneOfOneTokenReceiver(to).onOneOfOneReceived(msg.sender, address(0), data) ==
                OneOfOneTokenReceiver.onOneOfOneReceived.selector,
            "UNSAFE_RECIPIENT"
        );
    }
}