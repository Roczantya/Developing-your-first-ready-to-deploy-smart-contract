# 🔐 AFL 2: Smart Contract Security Audit

**CommunityRewardsVault Audit & Remediation**

---

## 📌 Executive Summary

This repository presents a comprehensive security audit of the `CommunityRewardsVault` smart contract. The audit combines three core methodologies:

* Static Analysis
* Symbolic Execution
* Property-based Fuzzing

All identified vulnerabilities have been successfully remediated to improve contract security and reliability.

---

## 🛠️ Security Tools Used

* **Slither** – Static analysis for vulnerability pattern detection
* **Mythril** – Symbolic execution for multi-transaction attack paths
* **Echidna** – Fuzz testing for invariant validation

---

## ⚠️ Vulnerabilities Found & Remediated

### 1. Reentrancy (High)

* Fixed by implementing the *Checks-Effects-Interactions (CEI)* pattern.

### 2. Unprotected Ether Withdrawal (Critical)

* Added access control using a custom `onlyOwner` modifier.

### 3. Accounting Invariant Violation (Medium)

* Corrected inconsistency in `totalVaultValue` discovered via Echidna fuzz testing.

---

## 🚀 Deployment Info

* **Network:** Sepolia Testnet
* **Contract Address:** `0xcac7cfc6fa476747d1b15fc63abce8acf02fb474`
* **Transaction:**
  https://testnet.routescan.io/tx/0x3f46f777f2d2a8cdfd9556d85f2043b1454f57bb61f70e9c0de6b9d1ca0fbdbc?chainid=11155111

---

## 🧪 How to Run the Audit

### 🔍 Slither

```bash
slither contracts/CommunityRewardsVault_Patched.sol
```

### 🧠 Mythril

```bash
myth analyze contracts/CommunityRewardsVault_Patched.sol
```

### 🧪 Echidna

```bash
echidna-test contracts/CommunityRewardsVault_Patched.sol --contract VaultTest
```

---

## 📁 Project Structure

```
contracts/
 ├── CommunityRewardsVault.sol
 └── CommunityRewardsVault_Patched.sol

test/
 └── (optional test files)

README.md
```

---

## 💡 Key Takeaways

* Demonstrates practical smart contract auditing workflow
* Covers detection, exploitation, and remediation
* Uses industry-standard security tools

---

## 👩‍💻 Author

Tiffany
