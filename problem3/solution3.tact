message Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint32;
    yesCount: Int as uint32;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint224;
}

contract Proposal(data: Init) {
    receive() {
        setCode(actual_code());
    }

    receive(msg: Vote) { }

    get fun proposalState(): ProposalState {
        return votes();
    }
}
asm fun votes(): ProposalState {}
asm fun setCode(code: Cell) {SETCODE}

asm fun dict_set_get(value: Slice, index: Slice, dict: Cell?, key_len: Int): Cell {DICTSETGET 1245 THROWIF}
asm fun actual_code(): Cell { B{b5ee9c724101020100750001c0ff00208e5230d72c20c9db1e6e31ed44d020f82302d35f01ab3f13bbf28201d70b7f03d0d70b2aa93806ae5330b0f24113b1019d01d70b5fa4c8cb5fcb7fc9ed548e1301d33f01a4c8cb3f01d71d1fcf16cb7fc9ed54e2e1f4a413f4bcf2c80b01001fa64e58bb5134200835c874c7f5c2c7e0de7fc8fa} B>boc PUSHREF }
