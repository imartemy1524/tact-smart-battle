struct ProposalInit {
    master: Address;
    proposalId: Int as uint32;
}

message DeployNewProposal {
    votingEndingAt: Int as uint32;

}
message DeployNewProposal2 {
    votingEndingAt: Int as uint32;
}
contract ProposalMaster {
    id: Int as uint32 = 0;
    // deploy
    receive() { }

    receive(msg: DeployNewProposal) {
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let state = initOf Proposal(ProposalInit{master: myAddress(), proposalId: self.id});
        self.id += 1;
        let addr = contractAddress(state);
        send(SendParameters{
            to: addr,
            mode: SendRemainingValue,
            body: DeployNewProposal2{
                votingEndingAt: msg.votingEndingAt
            }.toCell(),
            value: 0,
            code: state.code,
            data: state.data,
        });
    }
    get fun nextProposalId(): Int {
        return self.id;
    }
}

// ==============================================================================

message Vote {
    value: Bool;
}

struct ProposalState {
    yesCount: Int as uint32;
    noCount: Int as uint32;
    master: Address;
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32;
}

contract Proposal {
    yesCount: Int as uint32 = 0;
    noCount: Int as uint32 = 0;
    master: Address;
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32 = 0;
    data: map<Address, Bool> = emptyMap();
    init(data: ProposalInit){
        self.master = data.master;
        self.proposalId = data.proposalId;
    }
    receive(m: DeployNewProposal2){
        nativeThrowUnless(2025, sender() == self.master);
        self.votingEndingAt = m.votingEndingAt;
    }
    receive(msg: Vote) {
        require(self.votingEndingAt >= now(), "Proposal expired");
        require(self.yesCount + self.noCount < 100, "Vote limit exceeded");
        require(!self.data.exists(sender()), "User already voted");
        self.data.set(sender(), msg.value);
        if msg.value {
            self.yesCount = inc(self.yesCount);
        }
        else {
            self.noCount = inc(self.noCount);
        }
        self.replyOk();
    }

    get fun proposalState(): ProposalState {
        return ProposalState{
            yesCount: self.yesCount,
            noCount: self.noCount,
            master: self.master,
            proposalId: self.proposalId,
            votingEndingAt: self.votingEndingAt
        };
    }
    inline fun replyOk() {
        let msg2sender = beginCell()
        .storeUint(0x10, 6)
        .storeAddress(sender())
        .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
        .endCell();
        sendRawMessag(msg2sender, SendRemainingValue);

    }

}

asm fun sendRawMessag(msg: Cell, flags: Int) {SENDRAWMSG}
asm fun inc(s: Int): Int { INC }