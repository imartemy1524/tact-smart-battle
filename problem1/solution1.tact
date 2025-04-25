
message(1) Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint32;
    yesCount: Int as uint32;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint256;
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
asm fun actual_code(): Cell { B{b5ee9c724101010100810000fe8e7001d0800fd721d71dff207082008400c8cb1058cf16cb6ec98042fb00ed44d020f82302d31f5033bbf28201d33f01831fa90ca0c164f281f4058b161840338307f41af2d4dd02d72c200000000e319cd70b5fa4c8cb5ff400c9ed548e12d33f01a4c8cb3f01d71d1fcf16f400c9ed54e2e1ed44d08020d721d31fd70b1f40f26ac9} B>boc PUSHREF }
