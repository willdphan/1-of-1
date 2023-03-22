## One Of One NFTs

> A gas optimized ERC721 for 1:1 Editions

`OneOfOne.sol` does not keep track of NFT ids, automatically hardcodes an id of 1, and removes the id parameter in order to save gas. OneOfOne's operate like regular ERC721s. Double minting is not allowed.

Using the Minimal Proxy implementation, the `OneOfOneFactory.sol` is initiated with the OneOfOne implementation and deploys clones of the implementation with the createNFTContract function.

Feel free to read more about [EIP1167](https://eips.ethereum.org/EIPS/eip-1167).

`MinimalProxy.sol` shows the workflow of the minimal proxy implementation.

`OneOfOneProxy.sol` is an example contract that shows how to upgrade/build off of the original implementation contract without affecting the contract address or ABI used by clients.

[Contract Source](src/) • [Contract Tests](src/test/)
