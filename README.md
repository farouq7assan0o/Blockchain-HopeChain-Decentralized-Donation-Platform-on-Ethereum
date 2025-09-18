# HopeChain – Transparent Donation DApp

## Overview
HopeChain is a blockchain-based donation platform that ensures transparency, immutability, and accountability of charitable contributions. It replaces traditional opaque databases with smart contracts on Ethereum, enabling donors, regulators, and beneficiaries to verify transactions in real time.  

The system includes:
- A Solidity smart contract for secure donation and withdrawal logic.
- A web frontend (HTML + Ethers.js) for user interaction with MetaMask.
- A comprehensive documentation and analysis report covering governance, threats, privacy, regulation, and future improvements.

## Features
- **On-chain donation ledger**: Every donation records donor, amount, and timestamp permanently.
- **Spam protection**: 5-second cooldown per donor to reduce spam attempts.
- **Admin-only withdrawals**: Only the contract deployer can withdraw funds.
- **Events for transparency**: Emission of `Donated` and `Withdrawn` logs.
- **Web DApp**:
  - Wallet connection via MetaMask.
  - Easy donation submission.
  - Table of all donations and timestamps.
  - Admin-only dashboard for balance and withdrawals.

## Security
- Access control with `onlyAdmin` modifier.
- Zero-value donations blocked.
- Spam rate-limiting on donations.
- Analysis of key risks:
  - **Reentrancy attacks**: Mitigated by using `transfer()` and structured withdrawal.
  - **Single admin failure**: Needs multisig and ownership transfer.
  - **Sybil spam**: Multiple wallets can bypass throttle → requires off-chain controls.
  - **Privacy leaks**: Donor addresses exposed → future work includes zkSNARKs, mixers, or stealth addresses.
- Improvements proposed:
  - Pausable contracts for emergency stops.
  - Timelocks on large withdrawals.
  - Multi-signature wallets for shared governance.
  - Automated and manual audits for long-term security.

## Testing
- **Manual**:
  - Donations tested with MetaMask and displayed in frontend.
  - Non-admin withdrawals fail with access error.
  - Repeated donations within 5 seconds rejected.
- **Automated (suggested)**:
  - Hardhat test suite for unit/integration cases.
  - Slither/Mythril static analysis.
  - Event tracking verification.

```bash
# Example Hardhat setup
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npx hardhat test
** ## Documentation & Analysis**
  - Decentralization: Eliminates central server tampering risks.
  - Consensus: Ethereum’s Proof of Stake provides faster, greener confirmations.
  - Governance evolution: Proposes shift from single admin → multisig + on-chain voting.
  - Threats identified: Sybil attacks, admin lockout, donor privacy exposure.
  - Privacy solutions: zk-proofs, mixing, pseudonymous addresses.

  ## Legal analysis (Jordan):
  - NGO registration & compliance required.
  - Crypto banking restrictions challenge deployment.

Hybrid blockchain + traditional rails proposed.

Lessons from The DAO:

Explicit reentrancy guards.

Emergency pause switches.

Multisig with timelocks.

Continuous logging and monitoring.

## Technologies Used
  - Solidity 0.8.9 (Smart contract)
  - Ethereum (PoS) (Execution layer)
  - Remix IDE & Ganache (Development and testing)
  - MetaMask (Wallet integration)
  - Ethers.js v6 (Blockchain interaction in frontend)
  - HTML, CSS, JavaScript (User interface)
  - Hardhat (suggested) (Testing framework)

## Smart Contract (Solidity)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract HopeChain {
    address public admin;
    uint public donationCount;

    struct Donation {
        address donor;
        uint amount;
        uint timestamp;
    }

    mapping(uint => Donation) public donations;
    mapping(address => uint) public lastDonationTime;

    event Donated(address indexed donor, uint amount, uint timestamp);
    event Withdrawn(address indexed admin, uint amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function donate() public payable {
        require(msg.value > 0, "Cannot donate zero.");
        require(block.timestamp - lastDonationTime[msg.sender] > 5 seconds, "Wait 5s before donating again.");

        donationCount++;
        donations[donationCount] = Donation(msg.sender, msg.value, block.timestamp);
        lastDonationTime[msg.sender] = block.timestamp;

        emit Donated(msg.sender, msg.value, block.timestamp);
    }

    function getLastDonationTime(address _addr) public view returns (uint) {
        return lastDonationTime[_addr];
    }

    function getNow() public view returns (uint) {
        return block.timestamp;
    }

    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _amount) public onlyAdmin {
        require(_amount <= address(this).balance, "Insufficient funds.");
        payable(admin).transfer(_amount);

        emit Withdrawn(admin, _amount);
    }
}
## Frontend (HTML + Ethers.js)

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>HopeChain DApp</title>
  <script src="https://cdn.jsdelivr.net/npm/ethers@6.7.0/dist/ethers.umd.min.js"></script>
</head>
<body>
  <h2>HopeChain Donation DApp</h2>
  <button onclick="connectWallet()">Connect Wallet</button>
  <p id="walletAddress">Not connected</p>

  <h3>Donate</h3>
  <input type="number" id="donationAmount" placeholder="Amount in ETH">
  <button onclick="donate()">Donate</button>

  <div class="admin-only">
    <h3>Admin Withdraw</h3>
    <input type="number" id="withdrawAmount" placeholder="Amount in ETH">
    <button onclick="withdraw()">Withdraw</button>
  </div>

  <script>
    let provider, signer, contract;
    const contractAddress = "YOUR_DEPLOYED_ADDRESS";
    const contractABI = [
      "function donate() external payable",
      "function withdraw(uint256 _amount) external",
      "function getTotalBalance() public view returns (uint)",
      "function admin() view returns (address)",
      "function donationCount() view returns (uint)",
      "function donations(uint) view returns (address donor, uint amount, uint timestamp)"
    ];

    async function connectWallet() {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      provider = new ethers.BrowserProvider(window.ethereum);
      signer = await provider.getSigner();
      contract = new ethers.Contract(contractAddress, contractABI, signer);
      document.getElementById("walletAddress").innerText = `Connected: ${accounts[0]}`;
    }

    async function donate() {
      const ethAmount = document.getElementById("donationAmount").value;
      const tx = await contract.donate({ value: ethers.parseEther(ethAmount) });
      await tx.wait();
      alert("Donation successful!");
    }

    async function withdraw() {
      const amount = document.getElementById("withdrawAmount").value;
      const tx = await contract.withdraw(ethers.parseEther(amount));
      await tx.wait();
      alert("Withdrawal successful!");
    }
  </script>
</body>
</html>
## License
MIT License
