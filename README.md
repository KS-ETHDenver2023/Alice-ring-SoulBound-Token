
# **Alice's ring - SoulBound Token**

	This smart contract developed during the **ETHDenver 2023 hackathon** is a part of our solvency proof : This token proves that you have an x quantity of a specific token at a time t in an address without having to reveal it to the world.

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
truffle deploy --network matic
```
9. Verify your contract on etherscan
```
truffle run verify PoS_token --network matic
```

## **SoulBound Token (SBT)**📏

**1. What is a SoulBound Token ? **
		Soulbound tokens are non-transferable NFTs; once you acquire one, it will always be tied to your personal wallet and identity, and cannot be sold or given to another person. This makes them ideal to digitally represent assets that cannot be acquired by purchasing, such as certificates of competence, reputation, medical records, etc. 
**2. Why does Alice's ring need an SBT ? **
		Once our smart contract has verified the validity of the proof provided, it needs an object associated with the prover which can simply allow any individual to verify that the prover owns the desired quantity of tokens in his secret address. SoulBound Tokens fulfill this role perfectly.
SoulBound Tokens fulfill this role perfectly due to their non-fungibility and non-transferability.


## Technology 💻

 - [Tuffle Boxes](https://trufflesuite.com/boxes/)
 - [Infura RPC provider](https://www.infura.io/)
 - [Solidity](https://soliditylang.org/)
 - [OpenZeppelin](https://www.openzeppelin.com/)

	The use of Truffle boxes very easily allowed us to have a complete and intuitive front end to test our Smarts Contracts.
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

## Contribute ✨

Our project is intended as open source and as a tool for the Ethereum community and all web3 users. 
Feel free to contribute!

**Maxime - Thomas - Nathan - Adam | KRYPTOSPHERE®**