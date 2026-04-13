// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ==========================================
// 1. KONTRAK UTAMA (VULNERABLE VERSION)
// ==========================================
contract CommunityRewardsVault {
    mapping(address => uint256) public balances;
    uint256 public totalVaultValue; 
    address public owner;
    uint256 public rewardRate;

    constructor() {
        owner = msg.sender;
    }

    // HIDDEN BUG: Saldo individu bertambah, tapi totalVaultValue lupa di-update
    // Ini yang akan dideteksi oleh Echidna sebagai "Invariant Violation"
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        // SENGJA DIKOMENTAR/DIHAPUS UNTUK TESTING:
        // totalVaultValue += msg.value; 
    }

    // BUG: Reentrancy - Mengirim uang sebelum mengurangi saldo
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Saldo tidak cukup");

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer gagal");
        
        balances[msg.sender] -= _amount;
    }

    // BUG: Access Control - Siapa saja bisa jadi admin
    function setRewardRate(uint256 _newRate) public {
        rewardRate = _newRate;
    }

    function emergencyWithdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
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