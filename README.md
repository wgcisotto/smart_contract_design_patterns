# Design Patterns on Solidity Smart Contracts

## Goal

This project demonstrates the most common used design patterns on solidity smart contract

## Table of contents

* [Upgradable](#upgradability)


### Upgradability

There are few strategies to upgrade smart contracts. 

* Parameters Configuration
* Contracts Registry
* Strategy Pattern 
* Pluggable Modules

#### Upgrade Patterns


#### Proxies 

**Proxy** or **Proxy Delegate** is a delegation pattern commonly used to introduce upgradability in smart contracts

[**Transparent Proxy Pattern**](./contracts/upgradables/transparent_proxy/)

[ERC-1967](https://eips.ethereum.org/EIPS/eip-1967)

> Usually incorporates EIP-1967.

This proxy pattern address the *function selector clashing* by having admin functions on the proxy contract and logic funcions on the implementation contract. Only **admins** can proxy functions and **users** can only call implementation functions. 

**Universal Upgradeable Proxies (UUPS)** 

[ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)

All the logic of upgrading the smart contract goes to the implementations contract, in this case, the *function selector clashing* is catch by compiler time. 

**Diamond Proxy**

[ERC-2535](https://eips.ethereum.org/EIPS/eip-2535)

In diamond proxy solves the issues when you have a big smart contract that doesn't fit the contract maximum size abd need to break in smaller contracts using multi-implementation method besides, you can do granular upgrades. 

**Beacon Proxy**

 The Beacon pattern, stores the address of the implementation contract in a separate *beacon* contract. The address of the beacon is stored in the proxy contract using [ERC-1967](https://eips.ethereum.org/EIPS/eip-1967) storage pattern.



## Interaction with the code 

---

### Compile

```shell
yarn hardhat compile
```

`yarn hardhat compile`

### Tests

```shell
yarn hardhat test
```


# Resources

## Upgradability

### Proxies

* [OpenZepplin](https://docs.openzeppelin.com/contracts/4.x/api/proxy)
* [The State of Smart Contract Upgrades](https://blog.openzeppelin.com/the-state-of-smart-contract-upgrades/#upgrade-patterns)
