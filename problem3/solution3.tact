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
asm fun actual_code(): Cell { B{b5ee9c724101060100dd0002e6ff00208ee53001d0d3030101fa403002d31f01300171b08e2331d2000131ed44d0019dd33f01a5c8cb3f01cf16c9ed549ad35f30a5c8cb5fc9ed54e2e0ed44d020f82302d31f3012bbf2e57221d300309dd33f01a4c8cb3f01cf16c9ed549ad35f30a4c8cb5fc9ed54e2e1f4a413f4bcf2c80b0105015401c8f828cf1601cf16c98876c8cb04ccccc97621f9008200c400c8cb10cbffcb6f58cf16ccc98040fb00020114ff00f4a413f4bcf2c80b030128d330d0d3030130fa4030ed44d001d7263088ed5404000120001fa64e58bb5134200835c874c7f4c7cc20663d4703} B>boc PUSHREF }

