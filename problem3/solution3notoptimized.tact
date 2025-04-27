message Vote { value: Bool;}
struct ProposalState { yesCount: Int as uint32; noCount: Int as uint32; }
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32; }
asm fun NOW_PLUS_THING(): Int{
    now 3600 24 * + 10 + PUSHINT
}

contract Proposal {
    countA: Int as uint7 = 0;
    countB: Int as uint7 = 0;
    lastVoter: Address? = null;
    votingEndingAt: Int as uint32;
    init(data: Init) {
        // oh, ok...
        self.votingEndingAt = data.votingEndingAt;
    }

    // deploy
    receive() { }

    receive(msg: Vote) {
        require(self.lastVoter != sender(),"aaaa",);
//        require(self.votingEndingAt > now(),"bbbb",);
        require(now() < NOW_PLUS_THING(),"cccc");
        self.lastVoter = sender();

        if(msg.value){
            self.countA += 1;
        } else {
            self.countB += 1;
        }
    }

    get fun proposalState(): ProposalState {
        return ProposalState{
        yesCount: self.countA,
        noCount: self.countB,
        };
    }
}