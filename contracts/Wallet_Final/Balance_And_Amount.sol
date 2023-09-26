// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract BalanceAndAmount {

    function amountController(uint amount, uint senderBalance) external pure {
        require(amount <= senderBalance, "You can't spend more than you have.");
        require(amount > 0, "Amount has to be more than 0.");
    }
}