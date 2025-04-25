message(1) Vote { value: Bool;}
struct ProposalState { noCount: Int as uint32;yesCount: Int as uint32;}
struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint64;
}
message(0x1234) OnError{ owner: Address; vote: Bool;}

contract Proposal(data: Init) {
    receive(){
        setCode(actual_code());
    }

    receive(msg: Vote) { throw(123);}

    get(-14) fun proposalState(): ProposalState { return ProposalState{yesCount: 0, noCount: 0};}

}

asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
asm fun actual_code(): Cell { B{b5ee9c724101020100910001368e8c02821005f5e100be915be30de1ed44d08020d721d31fd70b1f0100e2ed44d020f82302d35f01ab3f13bbf28202d074d721fa403020c8cf850801cf168be00000000000000000000000000010cf16c98042fb0021c7005121c705b312b1f2e54102d72c200000000e319dd70b5fa4c8cb5f01cf16c9ed548e13d33f01a4c8cb3f01d71d1fcf1601cf16c9ed54e2ffd9289b} B>boc PUSHREF }
