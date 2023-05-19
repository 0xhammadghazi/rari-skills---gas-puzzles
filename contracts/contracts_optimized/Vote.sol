// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedVote {
    struct Voter {
        // Increased size of vote var from uint8 to uint248
        uint248 vote;
        bool voted;
    }

    struct Proposal {
        // Removed ended var cause it was not being used, and increased size of voteCount variable from uint8 to uint256
        uint256 voteCount;
        bytes32 name;
    }

    mapping(address => Voter) public voters;

    Proposal[] proposals;

    function createProposal(bytes32 _name) external {
        // Only assigning value to name and not initializing voteCount with default value.
        Proposal memory prop;
        prop.name = _name;
        proposals.push(prop);
    }

    function vote(uint248 _proposal) external {
        require(!voters[msg.sender].voted, 'already voted');

        voters[msg.sender].vote = _proposal;
        voters[msg.sender].voted = true;

        // Replaced assignment increment w/ increment operator;
        proposals[_proposal].voteCount++;
    }

    function getVoteCount(uint248 _proposal) external view returns (uint256) {
        return proposals[_proposal].voteCount;
    }
}
