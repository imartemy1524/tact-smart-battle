message(1) Vote { value: Bool;}
struct ProposalState { noCount: Int as uint32;yesCount: Int as uint32;}
struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint224;
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
asm fun actual_code(): Cell { B{b5ee9c724101040100ab0003fe8ef702821005f5e100b9f2d4d2ed44d020f82302d35f01ab3f13bbf2e57201d70b7f02d020d70b2aa938060174d721fa4030c8cf850801cf168be00000000000000000000000000010cf16c98042fb00ae840f5331b0f2f212b102d72c200000000e318e12d33f01a4c8cb3f01d71d1fcf16cb7fc9ed54e30de180f2f4a4130102030018d70b5fa4c8cb5fcb7fc9ed54001fa7fffcbb5134200835c874c7f4c7cc20000af4bcf2c80b684fcc00} B>boc PUSHREF }
