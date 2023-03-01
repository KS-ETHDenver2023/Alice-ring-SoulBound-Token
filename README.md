
# **Alice's ring - SoulBound Token**

This smart contract developed during the **ETHDenver 2023 hackathon** is a part of our solvency proof : This token proves that you have an x quantity of tokens at a time t in an address without having to reveal it to the world thanks.

## **Configuration** 📝

1. Clone this repo 
```
git clone https://github.com/KS-ETHDenver2023/SBT-to-prove-ownership.git
```
2. Install npm
```
npm install 
```
3. Install truffle
```
npm i truffle
```
4. Install hdWallet
```
npm i @truffle/hdwallet-provider
```
5. Install open zeppelin libraries
```
npm i @openzeppelin/contracts
```
6. Setup your .env file in the truffle folder
```
MNEMONIC="Your mnemonic"
API_KEY="Your infura api key"
ETHERSCAN="Your etherscan api key"
```
7. Compile using truffle 
```
truffle compile
```
8. Deploy using truffle 
```
truffle truffle deploy --network matic
```

## **Structure**📏

**1. Home page**

In this section you will learn more about our **Alice's ring project** and the "**proof of solvency**" that we can generate and issue thanks to ring signatures. There are many use cases and we have detailed some of them for you.

**2. Generate Proof of Solvancy**

-> need to be integrated

**3. zkBob - Direct Deposit 💸** 

Issuing **proof of solvency** is the first step before starting the anonymous transfer cycle. Indeed, after having attested to his solvency, the user may be required to transfer funds. 
But this step must not disclose its address and link it to its identity (see use cases).
**zkBob** gives you the freedom to deposit, transfer, and withdraw stable assets privately using **zk technology** paired with the BOB stablecoin. We have implemented the "Direct Deposit" feature and can find the smart contracts used in our dedicated Github repository.

In order to perform direct deposit actions via our smart contract, the user must first connect to our front end. Several wallets are available: **Metamask, WalletConnect, Coinbase Wallet and Rainbow.**
*Currently BOB transfers are only available on **Polygon** mainnet and the **sepolia** testnet.*

**Perform direct deposit :**

In order to perform a direct deposit you have to  **approve + desposit**  some funds

1. First time : Approve Alice's ring DirectDeposit smart contract to transfer BOB

2. Other : Check Alice's ring allowance balance (increase if necessary) and desposited funds

3. Deposit BOB tokens into Alice's ring smart contract

4. Perform Direct Deposit

5. Come back here ✨

**Generate a zkAddress to receive a transfer :**

If you are receiving funds from another zkBob user, you will want to send them a secure address. A new secure receiving address can be generated for each transfer.

Go to app.zkBob UI and click on  **Create ZkAccount**

1. Press the zkAccount button (your account should already be connected to initiate this process).

2. Press Generate receiving address.

3. Copy generated address and send to your friend via a private channel of your choice.

4. Come back here ✨

## Technology 💻

 - [React](https://reactjs.org/)
 - [Rainbowkit](https://www.rainbowkit.com/)
 - [wagmi](https://wagmi.sh/)
- [Infura RPC provider](https://www.infura.io/)
- [zkBob ](https://www.zkbob.com/)

Thanks to the large number of chains supported, we first used infura's RPCs for Polygon and Ethereum networks (mainnet&testnet).
The infura and truffle tools were also useful for the deployment of multi-chain smart contracts.
For Scroll and zkSync networks we used the RPCs provided in their respective documentations.

## Supported networks 🛰️

Currently, our application supports several networks but not all of them can be used for the same functionalities.

**Proof of Solvancy :**  
Mainnet (in development) : 
* [Polygon ](https://www.polygon.technology/)
* [Scroll ](https://scroll.io/)
* [zkSync ](https://zksync.io/)

Testnet (live) : 
* Polygon mumbai
* Scroll L1 testnet
* zkSync testnet
* Goerli

**zkBob - Direct Deposit :**

Due to zkBob choices, Direct Deposits can only be performed :

Mainnet (in development) : 
* [Polygon ](https://www.polygon.technology/)

Testnet (live) :
* Sepolia

## Contribute ✨

Our project is intended as open source and as a tool for the Ethereum community and all web3 users. 
Feel free to contribute!

**Maxime - Thomas - Nathan - Adam | KRYPTOSPHERE®**