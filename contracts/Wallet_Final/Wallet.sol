// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./Balance_And_Amount.sol";
import "./Safe_Math.sol";

contract SmartWallet is BalanceAndAmount {
    using SafeMath for uint256;

    mapping (address => Wallet) private wallets;

    BalanceAndAmount controller = new BalanceAndAmount();

    event LogError(string reason);

    struct Wallet {
        address owner;
        uint balance;
    }

    function deposit() public payable {
        wallets[msg.sender].balance = msg.value;
    }

    function withdraw(uint amount) public {
        uint senderBalance = wallets[msg.sender].balance;
        try controller.amountController(amount, senderBalance) {
            wallets[msg.sender].balance = wallets[msg.sender].balance.sub(amount);
            payable(msg.sender).transfer(amount);
        } catch Error(string memory reason){
            emit LogError(reason);
        }
    }

    function transfer(uint amount, address payable to) public {
        uint senderBalance = wallets[msg.sender].balance;
        try controller.amountController(amount, senderBalance) {
            wallets[msg.sender].balance = wallets[msg.sender].balance.sub(amount);
            wallets[to].balance = wallets[to].balance.add(amount);
        } catch Error(string memory reason) {
            emit LogError(reason);
        }
    }

    function showBalance() public view returns(uint) {
        return wallets[msg.sender].balance;
    }
}