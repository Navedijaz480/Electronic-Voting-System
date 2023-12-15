pragma solidity 0.5.0;

contract VoteSystem{

     
    struct vote{
        // unique address of eacch person
        address voterAddress;
        // choise person who want vote or not
        bool choise;
    }

    /*voter information */
    struct voter{
        string voterName;
        //to identify person who voted or not
        bool voted;
    }

    //total no of votes out of voters
    uint private countResult = 0;
    // get actual result
    uint public finalResult = 0;
    // to count total no of voter votes
    uint public totalVoter = 0;
    // how mach person votes out of register person
    uint public totalVotes =0;

    //ballote address to register voter 
    address public ballotAddress;
    //ballot name for indentification
    string public ballotName;
    //somthing for praposal
    string praposal;

    //mapping the votes
    mapping(uint => vote) private votes;
    //mapping register voter
    mapping(address => voter) public voterRegister;

    // three state for voting 
    enum State{Created,Voting,Ended} 
    State public state;


    modifier condition(bool _condition){
       require(_condition);
       _;
    }

    //only offical voter ballot person can start and end ,register vote system
    modifier onlyOfficial(){
       require(msg.sender == ballotAddress);
        _;
    }

    // tracking the states of votes
    modifier inState(State _state){
        require(state == _state);
        _;
    }

    constructor(string memory _ballotname,string memory _praposal) public {
        ballotAddress = msg.sender;
        ballotName = _ballotname;
        praposal = _praposal;
        state = State.Created;
    }

  
    // adder voster througth official ballot person
    function addVoter(address _voterAddress,string memory _voterName) 
    public
    inState(State.Created)
    onlyOfficial
    {

        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
    }

    
   //starting voting system
    function startVote() 
    public
    inState(State.Created)
    onlyOfficial
    {
       state = State.Voting;
    }

    /*
      each one can votes from register address
    */ 
    function doVote(bool _choise) 
    public 
    inState(State.Voting)
    returns(bool)
    {
         bool found = false;
         if(bytes(voterRegister[msg.sender].voterName).length!=0 && !voterRegister[msg.sender].voted){
           voterRegister[msg.sender].voted = true;
           vote memory v;
           v.voterAddress = msg.sender;
           v.choise = _choise;

           if(_choise){
               countResult++;
           }
           votes[totalVotes] = v;
           totalVotes++;
           found = true;
         }

         return found;
    }


    // End the voting
    function endVote()
     public
     inState(State.Voting)
     onlyOfficial
    {
      state = State.Ended;
      finalResult = countResult;
    }

}


