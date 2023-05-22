// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    // Do not modify these variables
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;

    // Optimize this function
    function purchaseToken() external payable {
        // Split both conditions into separate require statements.
        // Moved the entire code into an unchecked block (saved some gas because we are performing addition).

        unchecked {
            require(msg.value == 0.1 ether);
            require(block.timestamp > lastPurchaseTime + COOLDOWN);
            lastPurchaseTime = block.timestamp;
            // mint the user a token
        }
    }
}
