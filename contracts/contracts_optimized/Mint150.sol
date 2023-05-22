//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import 'hardhat/console.sol';

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721('NotRareToken', 'NRT') {}

    function mint() external {
        totalSupply++;
        console.log('Minter ', msg.sender);
        console.log('Token id ', totalSupply);
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract OptimizedAttacker {
    address public immutable deployer;
    NotRareToken public immutable victim;

    constructor(NotRareToken _victim) {
        console.log('deployer ', msg.sender);
        console.log('Attacker contract ', address(this));
        deployer = msg.sender;
        victim = _victim;
        // for (uint256 i = 0; i < 10; i++) {
        this.tryMint();
        // victim.mint();
        // }
    }

    function tryMint() public {
        victim.mint();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        console.log('Mic testing');
        victim.safeTransferFrom(address(this), deployer, 1);
        return IERC721Receiver.onERC721Received.selector;
    }
}
