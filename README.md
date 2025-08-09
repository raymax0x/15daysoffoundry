# 15 Days of Foundry (Web3Compass Challenge)

A 15-day learning and building streak using Foundry for smart contract development. Each day lives under its own folder (e.g., `Day1/`, `Day2/`, …) with code, tests, notes, and learnings.

## What is Foundry?
Foundry is a fast, portable, and modular toolkit for Ethereum application development written in Rust. It includes:
- forge: testing, building, and deploying smart contracts
- cast: CLI for interacting with EVM networks and contracts
- anvil: local Ethereum node

## Repo Structure
- `Day1/`, `Day2/`, …: Daily tasks, contracts, tests, and notes
- `lib/`: External libraries installed via `forge install`
- `out/`: Build artifacts
- `broadcast/`: Deployment & script run outputs
- `cache/`: Build cache

## Prerequisites
- Install Foundry: https://book.getfoundry.sh/getting-started/installation
  - On most systems: `curl -L https://foundry.paradigm.xyz | bash` then `foundryup`

## Common Commands
From a given day’s directory (or repo root if configured):
- Build: `forge build`
- Test: `forge test -vvv`
- Format: `forge fmt`
- Gas snapshots: `forge snapshot`
- Coverage (if available): `forge coverage`
- Local node: `anvil`
- Run script: `forge script script/YourScript.s.sol --rpc-url <RPC> --broadcast`

## Getting Started
1. Clone the repo
2. Enter a day folder, e.g. `Day1/`
3. Install libs if needed: `forge install`
4. Build & test:
   - `forge build`
   - `forge test -vvv`

## Notes
- Environment variables (e.g., private keys, RPC URLs) belong in a local `.env` that is NOT committed to version control.
- Each day’s `README.md` may contain specific goals, learnings, and references.

## License
Add your preferred license (e.g., MIT) if you plan to open source.
