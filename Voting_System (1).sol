// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting_System{
    address owner;
    struct candidate{
        string Name;
        string ImageHash;
        uint256 voteCount;
        bool isCreated;
    }
    
    mapping (address => bool) voted;

    mapping(string=>candidate) candidates;
    string[] candidateList;
    constructor (){
        owner=msg.sender;
    }

    modifier isOwner{
        require(owner==msg.sender);
        _;
    }

    function isOwnerCheck() public view returns(bool){
        return owner==msg.sender;
    }

    function add_candidate(string memory Name,string memory hash) public isOwner{
        candidates[Name].Name=Name;
        candidates[Name].ImageHash=hash;
        candidates[Name].voteCount=0;
        candidates[Name].isCreated=true;
        candidateList.push(Name);
    
    }

    function vote(string memory name) public{
        if(voted[msg.sender]==false && candidates[name].isCreated){
            candidates[name].voteCount+=1;
            voted[msg.sender]=true;
        }
    }

    function candidatesList() public view returns(candidate[] memory){
        candidate[] memory id=new candidate[](candidateList.length);
        for(uint256 i=0;i<candidateList.length;i++){
            id[i]=candidates[candidateList[i]];
        }
        return id;
    }



}

