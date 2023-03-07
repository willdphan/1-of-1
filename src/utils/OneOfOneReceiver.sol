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