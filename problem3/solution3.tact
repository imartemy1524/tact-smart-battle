
message Vote {
    value: Bool;
}

struct ProposalState {
    yesCount: Int as uint32;
    noCount: Int as uint32;
}

struct Init {
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32;
}

message(0x1234) OnError{
    owner: Address;
    vote: Bool;
}

inline fun packStateInit(init: StateInit): Cell{
    return beginCell()
    .storeUint(0, 2)
    .storeDict(init.code)
    .storeDict(init.data)
    .storeUint(0, 1)
    .endCell();

}
inline fun replyOk(to: Address) {
    let msg2sender = beginCell()
    .storeUint(0x10, 6)
    .storeAddress(to)
    .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
    .endCell();
    sendRawMessag(msg2sender, SendRemainingValue);
}
const MSG_INFO_REST_BITS: Int = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE: Int = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT: Int = 4;
const MSG_STATE_INIT_IN_REF: Int = 2;
const MSG_BODY_IN_REF: Int = 1;

contract Proposal {
    votingEndingAt: Int as uint32;
    currVotes: ProposalState = ProposalState{ yesCount: 0, noCount: 0};

    init(data: Init) {
        // oh, ok...
        self.votingEndingAt = data.votingEndingAt;
    }
    receive() { }

    receive(msg: Vote) {
        require(context().value > ton("0.05"), "Not enough value");
        self.requireNotExpired();

        if(msg.value){
            self.currVotes.yesCount += 1;
        } else {
            self.currVotes.noCount += 1;
        }
        let init: StateInit = initOf SingleVoteHolder(myAddress(), sender(), false);
        let addr = contractAddress(init);
        let state_init_packed = packStateInit(init);
        sendRawMessag(
            beginCell()
                .storeUint(0x10, 6)
                .storeAddress(addr)
                .storeUint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4)
                .storeRef(state_init_packed)
                .storeBool(msg.value)
//                .storeRef(msg.value?cell("te6cckEBAQEAAwAAAcCO6ba2"):cell("te6cckEBAQEAAwAAAUD20kA0"))
                .endCell(),
            SendRemainingValue
        );
    }

    get fun proposalState(): ProposalState {
        return self.currVotes;
    }
    inline fun requireNotExpired(){
        require(self.votingEndingAt >= now(), "Proposal expired");
    }
    receive(m: OnError){
        require(sender() == contractAddress(initOf SingleVoteHolder(myAddress(), m.owner, false)), "Only master can deploy");
        if(m.vote){
            self.currVotes.yesCount -= 1;
        } else {
            self.currVotes.noCount -= 1;
        }
        replyOk(m.owner);
    }
}

contract SingleVoteHolder(master: Address, owner: Address, status: Bool){
    receive(m: Slice){
        require(sender() == self.master, "Only master can deploy");
        let isTrue = m.loadUint(1) == 1;
        if(self.status){
            self.replyNotOk(isTrue);
        }
        else {
            self.status = true;
            replyOk(self.owner);
        }
    }
    inline fun replyNotOk(isok: Bool) {
        let msg2sender = beginCell()
        .storeUint(0x10, 6)
        .storeAddress(self.master)
        .storeUint(0x1234, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32))
        .storeAddress(self.owner)
        .storeBool(isok)
        .endCell();
        sendRawMessag(msg2sender, SendRemainingValue);
        commit();
        throw(1212);
    }
}

asm extends fun add(self: ProposalState): Int { ADD }

asm fun sendRawMessag(msg: Cell, flags: Int) { SENDRAWMSG }
asm extends fun storeDict(self: Builder, dict: Cell): Builder { SWAP STDICT }