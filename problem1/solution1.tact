
message(1) Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint32;
    yesCount: Int as uint32;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint100;
}

contract Proposal(data: Init) {
    receive(){
        setCode(actual_code());
    }
    receive(msg: Vote) { }

    get(-14) fun proposalState(): ProposalState {
        return ProposalState{
        yesCount: 0,
        noCount: 0
        };
    }

}
const SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE: Int = 64;


asm extends fun add(self: ProposalState): Int { ADD }
asm fun inc(s: Int): Int { INC }
asm fun sendRawMessag(msg: Cell, flags: Int) {
    SENDRAWMSG
}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
struct Addr{
    chain: Int;
    hash: Int;
}
asm fun parse_std_addr(s: Address): Addr {
    REWRITESTDADDR
}
asm fun actual_code(): Cell { B{b5ee9c724101030100ae0002ee8eea01d0ed44d020f82302d31f5033bbf28101d33f01831fa90ca0c164f282f405802d7053044313800e01d7348b0802800ef41af2d4dd03d72c200000000e319dd70b5fa4c8cb5f12f400c9ed548e13d33f01a4c8cb3f01d71d1fcf1612f400c9ed54e274d72181010bd719e180f2f4a413f4bcf2c80b0102003e8010c8cb0501cf168be00000000000000000000000000010cf16c98042fb00001fa7fffcbb5134200835c874c7f4c7cc20494b4954} B>boc PUSHREF }
