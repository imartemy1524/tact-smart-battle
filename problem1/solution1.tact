
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
trait TimeLimited{
    votingEndingAt: Int as uint32;
    inline fun requireNotExpired(){
        require(self.votingEndingAt >= now(), "Proposal expired");
    }
}

contract Proposal with TimeLimited {
    data: map<Address, Bool> as uint32;
    votingEndingAt: Int as uint32;
    currVotes: ProposalState = ProposalState{
    yesCount: 0,
    noCount: 0
    };
    init(data: Init) {
        self.data = emptyMap();
        self.votingEndingAt = data.votingEndingAt;
    }
    // deploy
    receive() { }

    receive(msg: Vote) {
        self.requireNotExpired();
        require(self.currVotes.add() < 100, "Vote limit exceeded");
        require(!self.data.exists(sender()), "User already voted");
        self.data.set(sender(), msg.value);
        if msg.value {
            self.currVotes.yesCount = inc(self.currVotes.yesCount);
        } else {
            self.currVotes.noCount = inc(self.currVotes.noCount);
        }
        self.replyOk();
    }

    get fun proposalState(): ProposalState {
        return self.currVotes;
    }
    inline fun replyOk() {
        let msg2sender = beginCell()
        .storeUint(0x10, 6)
        .storeAddress(sender())
        .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
        .endCell();
        sendRawMessag(msg2sender, SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);

    }
}
const SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE: Int = 64;


asm extends fun add(self: ProposalState): Int { ADD }
asm fun inc(s: Int): Int { INC }
asm fun sendRawMessag(msg: Cell, flags: Int) {
    SENDRAWMSG
}