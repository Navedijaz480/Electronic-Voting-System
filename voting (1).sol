//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
  
  /*
  @title DelegateVoting
  @author Vivek Tyagi
  @dev All functions are working without any side-effect
  @notice Transparent and Secure way to vote among the different proposals
  */
contract DelegateVoting{
  /*
  @notice structure of Proposal
  */
  struct Proposal{
      bytes32 name;
      uint noOfVotes;
  }
  /*
  @notice structure of Voter
  */
  struct Voter{
      bool isVoted;//wheter vote or not
      address delegatedVoter;//wheter transferred his/her vote to another
      uint votedProposal;//vote to which proposal
      uint weight;//no of delegations to vote..
  }
  /*
  @notice Address of chairperson
  */
  address public chairperson;
  /*
  @dev stores the struct elements at time of deployment 
  */
  Proposal[] public proposalNames;
  /*
  @dev stores the key-value pair of address to Voter struct
  */
  mapping(address=>Voter) public addressToVoter;
  /*
  @dev includes require statement to allow only chairman to run the function which is using this modifier
  */
  modifier onlyChairman() {
   require(msg.sender == chairperson,"Only Chairperson"); 
   _;
  }
  /* 
  @dev set msg.sender as chairman and pushes the elements in parameters in the proposalNmes array..
  @param _proposalNames Take array of bytes32 elements as parameter
  */
  constructor(bytes32[] memory _proposalNames){
    chairperson = msg.sender;
    for(uint i=0; i<_proposalNames.length; i++){
     proposalNames.push(Proposal({
     name:_proposalNames[i],
     noOfVotes:0
     }));
    }
  }
  /*
  @dev Will increase the voter weight by 1 and only called by the chairman
  @param _voterAddress Takes address of person who is going to vote
  */
  function rightToVote(address _voterAddress) public onlyChairman {
    Voter storage _voter = addressToVoter[_voterAddress];
    require(_voter.weight == 0,"Already Added");
    _voter.weight = 1;
  }
  /*
  @dev 1)Sets voter isVoted to be true and increase the weight of 'to'
       2)Also increase the weight of address 'to' by the weight of msg.sender weight
  @notice Transfer the vote to delegated voter
  @param to Takes address of delegated voter
  */
  function delegatedVoter(address to) external {
    Voter storage _voter = addressToVoter[msg.sender];
    require(msg.sender != chairperson,"Chairperson can't delegate.");
    require(_voter.weight >= 1,"Not Registered"); 
    require(!_voter.isVoted,"Already Voted");
    Voter storage _delegate = addressToVoter[to];
    require(_delegate.weight >= 1);
    _voter.isVoted = true;
    _voter.delegatedVoter = to;
    if(_delegate.isVoted){
     proposalNames[_delegate.votedProposal].noOfVotes+=_voter.weight;
     _delegate.weight+=_voter.weight;
     _voter.votedProposal = _delegate.votedProposal;
    }
    else{
        _delegate.weight+=_voter.weight;
    }
  }
  /*
  @dev sets msg.sender isVoted property to be true
  @notice allow voters to vote their desirable proposal
  @param _proposalIndex Takes the index no. of proposal stores in proposalNames array
  */
  function vote(uint _proposalIndex) external{
    Voter storage _voter = addressToVoter[msg.sender];
    require(msg.sender != chairperson,"Chairperson can't vote");
    require(_voter.weight>=1,"Not eligible to vote");
    require(!_voter.isVoted,"Already Voted");
    proposalNames[_proposalIndex].noOfVotes+=_voter.weight;
    _voter.isVoted = true;
    _voter.votedProposal = _proposalIndex;
  }
  /*
  @dev loop through proposalNames array to find the most vote count from one of the proposals.
  @notice Returns the index of winner
  @return _winn ingProposal returns the index number of the winning proposal from proposalNames
  */
  function winningProposal() public view onlyChairman returns(uint _winningProposal){
    uint winningVoteCount;
    for(uint j=0;j<proposalNames.length;j++){
     if(proposalNames[j].noOfVotes>winningVoteCount){
     winningVoteCount = proposalNames[j].noOfVotes;
     _winningProposal = j;
     }
     else{
      winningVoteCount = winningVoteCount;
     }
    }
  } 
  /*
  @dev returns the name of the winner in form of bytes32
  @notice return the winner name
  @return String in form of bytes32
  */
  function winnerName() public view onlyChairman returns(bytes32){
    return proposalNames[winningProposal()].name;
  }
}