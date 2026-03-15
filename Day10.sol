// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ShiliuProfessionalVault is Ownable {
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event EmergencyWithdraw(uint256 amount);

    constructor() Ownable(msg.sender) {}

    function deposit() public payable {
        require(msg.value > 0, "No ETH sent");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        balances[msg.sender] -= _amount;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
    }

    function getVaultTotal() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
