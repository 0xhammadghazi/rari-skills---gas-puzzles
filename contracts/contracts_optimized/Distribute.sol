// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address payable immutable contributor1;
    address payable immutable contributor2;
    address payable immutable contributor3;
    address payable immutable contributor4;

    uint256 public immutable createTime;
    uint256 public immutable amount;

    // Used selfdestruct to transfer eth to last contributor (saves 4k gas, send costs around 9k whereas selfdestruct around 4k)
    // Used 4x immutable contributors var instead of a 4 length array
    // Calculated amount in constructor and made it immutable
    // Only setting createTime during constructor initialisation hence made it immutable as well
    // Used send to transfer eth instead of transfer (send is cheaper as it doesn't revert if the transfer is failed)

    constructor(address[4] memory _contributors) payable {
        contributor1 = payable(_contributors[0]);
        contributor2 = payable(_contributors[1]);
        contributor3 = payable(_contributors[2]);
        contributor4 = payable(_contributors[3]);
        createTime = block.timestamp;
        amount = address(this).balance / 4;
    }

    function distribute() external {
        require(
            block.timestamp > createTime + 1 weeks,
            'cannot distribute yet'
        );
        contributor1.send(amount);
        contributor2.send(amount);
        contributor3.send(amount);
        selfdestruct(contributor4);
    }
}
