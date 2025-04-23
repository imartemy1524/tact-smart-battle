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
asm fun actual_code(): Cell { B{b5ee9c72410206010001050002faff00208eef3001d0d3030101fa403002d31f01300171b08e2331d2000131ed44d0019dd33f01a5c8cb3f01cf16c9ed549ad35f30a5c8cb5fc9ed54e2e0ed44d020f82302d31f3012bbf2e57221d300309dd33f01a4c8cb3f01cf16c9ed549ad35f30a4c8cb5fc9ed54e221fa44c83202cf16cbffe1f4a413f4bcf2c80b0105015c01d30030c8f828cf16cb04c98876c8cb04ccccc97621f90083098018c8cb05cb0acbffcb6f58cf17ccc98040fb00020114ff00f4a413f4bcf2c80b03015ed301d0d3030130fa4030ed44d021d726f404300271d7218801d3ff3055028307f46f6ef2e575c858cf16f400c9ed54040000001fa64e58bb5134200835c874c7f4c7cc2085baaea2} B>boc PUSHREF }

