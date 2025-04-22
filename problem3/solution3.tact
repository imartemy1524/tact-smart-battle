message Vote { value: Bool;}
struct ProposalState { yesCount: Int as uint32;noCount: Int as uint32;}
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32;}
message(0x1234) OnError{ owner: Address; vote: Bool;}

contract Proposal {

    init(data: Init) {
        setData(
            beginCell()
                .storeUint(data.votingEndingAt << 64, 32 + 64)
            .endCell()
        );
        setCode(actual_code());
        commit();
        throw(0);
    }
    receive(){}

    receive(msg: Vote) { throw(123);}

    get fun proposalState(): ProposalState { return ProposalState{yesCount: 0, noCount: 0};}

}

asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
asm fun actual_code(): Cell { B{b5ee9c724102050100011d0003eaff00208f673001d0d3030130fa403001d31f01c0018ec7fa40d200013101c8f828cf1601cf16c98876c8cb04ccccc9f9008309c8cb0acbffc9d012c705f2e572ed44d0019dd33f01a4c8cb3f01cf16c9ed549ad35f30a4c8cb5fc9ed54e2e0ed44d0f82301d31f30bbf2e572e1f4a413f4bcf2c80b020104015401c8f828cf1601cf16c98876c8cb04ccccc97621f9008200c400c8cb10cbffcb6f58cf16ccc98040fb00020114ff00f4a413f4bcf2c80b0300aad320c700915be001d0d3030171b0915be0fa4030ed44d020fa405113c705f2e3e7fa40c7008e257fc85003cf1612ca00c9ed5458718010c8cb055004cf1613cb8e01cf1601cf16c98042fb00975f04f80ff2c4bce2001fa64e58bb5134200835c874c7f4c7cc20618e4ee6} B>boc PUSHREF }

