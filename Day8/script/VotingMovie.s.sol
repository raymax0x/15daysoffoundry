// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {VotingMovie} from "../src/VotingMovie.sol";

contract VotingScript is Script {
    function run() public {
        vm.startBroadcast();
        // VotingMovie voteM = new VotingMovie();
        // console.log("voteM", address(voteM));

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address voteContractAddress = vm.envAddress("CONTRACT_ADDRESS");

        VotingMovie voteM = VotingMovie(voteContractAddress);
        // console.log(" deployed to:", address(voteM));

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
