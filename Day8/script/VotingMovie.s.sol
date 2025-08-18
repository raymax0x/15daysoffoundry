// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {VotingMovie} from "../src/VotingMovie.sol";

contract VotingScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address voteContractAddress = vm.envAddress("VOTING_CONTRACT_ADDRESS");
        vm.startBroadcast();

        VotingMovie voteM = VotingMovie(voteContractAddress);
        console.log("contract deployed to:", address(voteM));

        // Lets interact with our contract, log the movies

        (string[] memory movies, uint256[] memory votes) = voteM.getAllVotes();
        console.log("Movies available for voting:");
        for (uint256 i = 0; i < movies.length; i++) {
            console.log("Movie", i);
            console.log("Name:", movies[i]);
            console.log("Votes:", votes[i]);
            console.log("---");
        }

        vm.stopBroadcast();
    }
}
