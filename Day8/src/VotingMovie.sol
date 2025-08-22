// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;
import "@openzeppelin-contracts/access/Ownable.sol";

contract VotingMovie is Ownable {
    string[] public movieToVote;
    mapping(uint256 => uint256) public voteData;
    mapping(address => bool) public hasVoted;

    constructor() Ownable(msg.sender) {
        movieToVote.push("The Shawshank Redemption");
        movieToVote.push("The Godfather");
        movieToVote.push("The Dark Knight");
        movieToVote.push("Pulp Fiction");
        movieToVote.push("Schindler's List");
    }

    function submitYourVote(uint256 movieIndex) public {
        require(movieIndex < movieToVote.length, "Invalid movie index");
        require(!hasVoted[msg.sender], "Already voted for this movie");
        voteData[movieIndex] += 1;
        hasVoted[msg.sender] = true;
    }

    function checkWinner()
        public
        view
        returns (uint256 movieIndex, string memory movieName)
    {
        uint256 highestVoteCount = 0;
        uint256 winningMovieIndex = 0;
        for (uint256 i = 0; i < movieToVote.length; i++) {
            if (voteData[i] > highestVoteCount) {
                highestVoteCount = voteData[i];
                winningMovieIndex = i;
            }
        }
        return (winningMovieIndex, movieToVote[winningMovieIndex]);
    }

    function getAllVotes()
        public
        view
        returns (string[] memory votedMovies, uint256[] memory votes)
    {
        uint256 length = movieToVote.length;
        votedMovies = new string[](length);
        votes = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            votedMovies[i] = movieToVote[i];
            votes[i] = voteData[i];
        }

        return (votedMovies, votes);
    }
}
