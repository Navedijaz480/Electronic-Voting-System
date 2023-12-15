// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract voting{
    // mapping(string => uint) votes;
    
    struct candidate {
        string name;
        uint votes;
        bool isRegistered;
    }
    mapping(string => candidate) candidates;
    uint index = 0;
    string[] candidateList;

    function register_candidate(string memory Name) public {
        require(!candidates[Name].isRegistered, "Candidate is already registered");
        candidates[Name] = candidate(Name, 0, true);
        candidateList.push(Name);
    }

    function vote(string memory Name) public {
        require(candidates[Name].isRegistered, "Candidate not registered");
        candidates[Name].votes++;
    }

    function get_candidates() public view returns(string[] memory) {
        return candidateList;
    }

    function results() public view returns(string memory, string memory, string memory, uint) {
        string memory winner = candidateList[0];
        uint maxVotes = candidates[winner].votes;
        for(uint i = 1 ; i < candidateList.length ; i++) {
            if(maxVotes < candidates[candidateList[i]].votes) {
                maxVotes = candidates[candidateList[i]].votes;
                winner = candidateList[i];
            }
        }
        return ("The winner is: ", winner, "\nwith total votes: ", maxVotes);
    }

} 
