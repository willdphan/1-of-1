// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// The 1:1 implementation and the basic functionality
import "lib/openzeppelin-contracts/contracts/utils/Context.sol";
import "src/utils/Initializable.sol";

// based off of https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol
// only 1 mint is allowed with ID of 1
// only the owner of 1:1 can burn
// add Royalty component???

contract OneOfOne is Context, Initializable {
    
    /// EVENTS ///

    event Transfer(address indexed from, address indexed to);

    event Approval(address indexed owner, address indexed spender);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    ///  METADATA STORAGE/LOGIC ///

    string public name;

    string public symbol;

    /// BALANCE/OWNER STORAGE ///

    mapping(uint256 => address) internal _ownerOf;

     // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    function balanceOf(address owner) public view virtual returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    function ownerOf() public view virtual returns (address owner) {
        require((owner = _ownerOf[1]) != address(0), "NOT_MINTED");
    }

    /// APPROVAL STORAGE ///

    // to prevent being minted twice
    bool private _minted;

    mapping(uint256 => address) public getApproved;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /// CONSTRUCTOR ///

    function initialize (string memory _name, string memory _symbol) public initializer {
        name = _name;
        symbol = _symbol;
    }

    /// LOGIC ///

    function approve(address spender) public virtual {
        address owner = _ownerOf[1];

        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");

        getApproved[1] = spender;

        emit Approval(owner, spender);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(
        address from,
        address to
    ) public virtual {
        require(from == _ownerOf[1], "WRONG_FROM");

        require(to != address(0), "INVALID_RECIPIENT");

        require(
            msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[1],
            "NOT_AUTHORIZED"
        );

        _ownerOf[1] = to;

        delete getApproved[1];

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

        // Counter overflow is incredibly unrealistic.
        unchecked {
            _balances[to]++;
        }

        _ownerOf[1] = to;

        emit Transfer(address(0), to);
    }

    function _burn() public virtual {
        address owner = _ownerOf[1];

        require(owner != address(0), "NOT_MINTED");

        // Ownership check above ensures no underflow.
        unchecked {
            _balances[owner]--;
        }

        delete _ownerOf[1];

        delete getApproved[1];

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

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
contract OneOfOneTokenReceiver {
    function onOneOfOneReceived(
        address,
        address,
        bytes calldata
    ) external virtual returns (bytes4) {
        return OneOfOneTokenReceiver.onOneOfOneReceived.selector;
    }
}