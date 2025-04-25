message Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint32;
    yesCount: Int as uint32;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint64;
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
const SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE: Int = 64;
inline fun setDataItemOrThrow(data: Cell?, sender: Slice): Cell{
    return dict_set_get("a".asSlice(), sender, data, 32);
}
asm fun votes(): ProposalState{}
asm extends fun add(self: ProposalState): Int {
    ADD }
asm fun sendRawMessag(msg: Cell, flags: Int) {
    SENDRAWMSG
}
asm fun setCode(code: Cell) {SETCODE}

asm fun dict_set_get(value: Slice, index: Slice, dict: Cell?, key_len: Int): Cell {DICTSETGET 1245 THROWIF}
asm fun actual_code(): Cell { B{b5ee9c7241010201008d0001f0ff00208e6a30d72c20c9db1e6c8e59ed44d020f82302d31f5033bbf2e572018040d72120d74993d70bff923070e203d08024d721d70b07ae840f5341b0f2f213b101c7039d01d35f30a4c8cb5fcbffc9ed548e1301d33f01a4c8cb3f01d61f30cf16cbffc9ed54e2955b840ff2f0e2e1f4a413f4bcf2c80b01001fa64e58bb5134200835c874c7f4c7cc20d704f514} B>boc PUSHREF }
