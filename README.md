# HopeChain – Decentralized Donation Platform on Ethereum

## **Overview**

HopeChain is a blockchain-based decentralized donation platform built on the Ethereum network. It enables transparent, tamper-proof, and trustless donation tracking using smart contracts, with an accessible frontend and strong access control. The platform was designed to solve real-world transparency and accountability issues in traditional charity systems.

## **Features**

- **Smart Contract in Solidity**: Records and stores every donation immutably.
- **Ethers.js Frontend**: Connects users' wallets (via MetaMask) to a live donation DApp.
- **Admin-only Withdrawals**: Ensures only authorized fund release.
- **Rate-limiting**: Prevents donation spam using on-chain timestamp tracking.
- **Real-time Display**: Users can see all donations, contract balance, and last donation.
- **Event Emissions**: For off-chain monitoring and blockchain transparency.

## **Smart Contract Functions**

```solidity
function donate() public payable
function withdraw(uint _amount) public onlyAdmin
function getTotalBalance() public view returns (uint)
function getLastDonationTime(address _addr) public view returns (uint)
function getNow() public view returns (uint)
````

* `donate()`: Accepts ETH and records donor address, amount, and timestamp.
* `withdraw()`: Allows the admin to withdraw funds, protected by `onlyAdmin` modifier.
* `getTotalBalance()`: Displays total ETH balance in the contract.
* `getLastDonationTime()`: Prevents rapid re-donations to mitigate spam.
* `getNow()`: On-chain timestamp utility.

## **Frontend Functionality (index.html)**

* **Connect Wallet**: MetaMask integration
* **Donation Entry**: ETH input and real-time donation confirmation
* **Admin Withdrawals**: UI protected based on connected wallet
* **Live Contract Data**: Display contract balance and donation history
* **Donation Table**: Dynamic rendering of all previous donations

## **Security and Governance**

* **Admin-Only Access**: Set during contract deployment
* **Replay Attack Mitigation**: Uses timestamp and mapping for rate-limiting
* **Withdrawal Validation**: Requires sufficient balance

### **Events Logged**

* `Donated(address donor, uint amount, uint timestamp)`
* `Withdrawn(address admin, uint amount)`

## **Key Lessons and Reflections**

* **Identified Reentrancy Risks**: Added `.transfer()` instead of `.call()` to avoid exploits
* **Single Point of Failure**: Future upgrades include multisig wallets and emergency recovery
* **Donor Privacy Risks**: Explored zk-SNARKs, ring signatures, and address freshness
* **Legal Compliance Research**: Analyzed Jordanian law conflicts and potential hybrid models
* **Sybil Resistance**: Highlighted spam vulnerability via multiple wallet generation
* **DAO Hack Analysis**: Studied real-world exploit and applied mitigation patterns

## **Tech Stack**

* **Solidity (v0.8.9)** – Smart Contract Logic
* **Remix IDE** – Contract Compilation and Deployment
* **Ethers.js** – Wallet and blockchain interaction
* **MetaMask** – Ethereum wallet integration
* **HTML/CSS/JS** – Web interface

## **How to Run Locally**

1. Install MetaMask and fund a wallet with test ETH on Goerli or Sepolia.
2. Deploy contract via Remix using `HopeChain.sol`.
3. Replace contract address in `index.html` JavaScript.
4. Open `index.html` in a browser, connect your wallet, and interact with the DApp.

## **Future Improvements**

* Add `transferOwnership()` or multisig support for admin control
* Introduce donor pseudonymity using zk-proofs or address freshness
* Implement frontend spam filtering and ENS-based trust scoring
* Expand dashboard for donation analytics and proposal-based fund allocation

## **Author**

Farouq Hassan
Spring 2023–2024
HTU – Blockchain Development
Supervisor: Sami AlMashaqbeh
