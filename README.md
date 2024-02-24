## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

Project Overview:
The goal is to create a bridge between an EVM-compatible chain and a non-EVM chain, allowing users to lock assets on one chain and release corresponding assets on the other. This includes support for ERC20 and native token locks.

Design Decisions:
Choice of Blockchain:

Decide on the EVM-compatible chain (e.g., Ethereum) and the non-EVM chain (e.g., Solana).
Choose the appropriate smart contract language (e.g., Solidity for Ethereum, Rust for Solana).
Smart Contract Architecture:

Choose a modular and upgradable architecture.
Use OpenZeppelin contracts for ERC20 functionality.
Technical Architecture:
Lock Contract on EVM Chain:

Implement a LockContract on the EVM chain.
Include events for tracking lock details.
Support locking ERC20 tokens and native ETH.
Release Contract on Non-EVM Chain:

Implement a corresponding ReleaseContract on the non-EVM chain.
Verify lock events, possibly through oracles.
Include a secure communication mechanism.
Implementation:
Lock Contract (Solidity):

Implement functions for locking ERC20 tokens, native ETH, and a fallback function for ETH.
Emit events for ERC20 and ETH locks.
Ensure the contract can be owned and includes a withdrawal mechanism.
Release Contract (Rust):

Implement a ReleaseContract that interacts with the EVM Lock Contract.
Verify the authenticity of lock events, possibly through oracles.
Develop secure communication channels.
Challenges Faced:
Decimal Differences:

Address any decimal differences between tokens on different chains.
Secure Communication:

Ensure secure communication between the EVM and non-EVM chains.
Resolutions:
Decimal Handling:

Implement a conversion mechanism to handle decimal differences.
Secure Communication:

Use cryptographic techniques for secure communication.
