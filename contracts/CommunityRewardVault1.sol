// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// TIDAK ADA IMPORT DI SINI (Bersih dari error "File not found")

contract CommunityRewardsVault {
    mapping(address => uint256) public balances;
    uint256 public totalVaultValue; 
    uint256 public rewardRate;
    address public owner;
    
    // Guard manual untuk Reentrancy
    bool private locked;

    // FIX ACCESS CONTROL: Modifier manual pengganti "Ownable"
    modifier onlyOwner() {
        require(msg.sender == owner, "Bukan owner");
        _ ;
    }

    // FIX REENTRANCY: Modifier manual pengganti "ReentrancyGuard"
    modifier noReentrancy() {
        require(!locked, "Reentrancy terdeteksi");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }

    // FIX ACCOUNTING: Pastikan totalVaultValue di-update (Target Echidna)
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        totalVaultValue += msg.value; 
    }

    // FIX REENTRANCY: Pakai pola Checks-Effects-Interactions (Target Slither)
    function withdraw(uint256 _amount) public noReentrancy {
        require(balances[msg.sender] >= _amount, "Saldo tidak cukup");

        // 1. Effects: Kurangi saldo dulu sebelum kirim uang
        balances[msg.sender] -= _amount;
        totalVaultValue -= _amount; 

        // 2. Interactions: Kirim uang
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer gagal");
    }

    function setRewardRate(uint256 _newRate) public onlyOwner { 
        rewardRate = _newRate;
    }

    function emergencyWithdraw() public onlyOwner { 
        uint256 amount = address(this).balance;
        totalVaultValue = 0;
        payable(owner).transfer(amount);
    }

    receive() external payable {
        deposit();
    }
}

contract VaultTest is CommunityRewardsVault {
    // WAJIB: Ada "echidna_" di depan, dan "returns (bool)" di belakang
    function echidna_check_accounting() public view returns (bool) {
        // Logika: totalVaultValue HARUS SAMA dengan saldo asli kontrak.
        // Karena di deposit() baris update totalVaultValue kita hapus, 
        // maka saat Echidna kirim duit, ini akan jadi FALSE.
        return (totalVaultValue == address(this).balance);
    }

    // Pancingan: Biar Echidna lebih agresif kirim ETH
    function test_deposit() public payable {
        deposit();
    }
}
