message(1) Vote {
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

    get(-14) fun proposalState(): ProposalState {
        return votes();
    }
}
asm fun votes(): ProposalState {}
asm fun setCode(code: Cell) {SETCODE}

asm fun dict_set_get(value: Slice, index: Slice, dict: Cell?, key_len: Int): Cell {DICTSETGET 1245 THROWIF}
asm fun actual_code(): Cell { B{b5ee9c7241010101005f0000ba8e4ed72c200000000e31ed44d020f82302d35f01ab3f13bbf28201d70b2a03d0d70b2a23c0005141bd14b1f281019cd70b5fa4c8cb5fcb2ac9ed548e12d33f01a4c8cb3f01d71d1fcf16cb2ac9ed54e2e1ed44d08020d721d31fd70b1f6f1553d9} B>boc PUSHREF }
