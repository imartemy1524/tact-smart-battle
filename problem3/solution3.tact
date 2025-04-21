


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
    receive() {
        setCode(actual_code());
    }

    receive(msg: Vote) {
        throw(123);
    }

    get fun proposalState(): ProposalState {
        throw(123);
    }


}


asm extends fun add(self: ProposalState): Int { ADD }

asm fun setCode(code: Cell) {
    SETCODE
}
asm fun sendRawMessag(msg: Cell, flags: Int) { SENDRAWMSG }
asm extends fun storeDict(self: Builder, dict: Cell): Builder { SWAP STDICT }

asm fun actual_code(): Cell { B{blablabla} B>boc PUSHREF }
