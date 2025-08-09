## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Day 1: Foundry Setup & First Contract (Counter.sol)

- **Goals**: Initialize a Foundry project, compile, test, and interact with a basic contract.
- **Concepts**: `forge init`, project layout, `forge build`, `forge test`.
- **Example App**: `src/Counter.sol` with `setNumber(uint256)` and `increment()` updating `number`.
- **Files in this day**:
  - `src/Counter.sol`
  - `test/Counter.t.sol`
  - `script/Counter.s.sol`
  - `foundry.toml`

### Quickstart
- Build: `forge build`
- Test (verbose): `forge test -vvv`
- Local node: `anvil`
- Script (example):
  ```bash
  forge script script/Counter.s.sol:CounterScript \
    --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
  ```

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
