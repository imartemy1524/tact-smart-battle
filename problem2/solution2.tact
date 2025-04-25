struct ProposalInit {
    master: Address;
    proposalId: Int as uint6;
}

message(2) DeployNewProposal {
    votingEndingAt: Int as uint32;
}
inline fun packStateInit(data: Cell): Cell{
    return beginCell()
    .storeUint(0b110, 5)
    .storeRef(proposalCode())
    .storeRef(data)
    .endCell();
}
const MSG_INFO_REST_BITS: Int = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE: Int = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT: Int = 4;
const MSG_STATE_INIT_IN_REF: Int = 2;
const MSG_BODY_IN_REF: Int = 1;

contract ProposalMaster() {

    // deploy
    receive() { }

    receive(msg: DeployNewProposal) {
        let data = getData().asSlice();
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let id = bool(data.bits()) ? data.loadUint(10) + 1 : 0;

        setData(
            beginCell().storeUint(id, 10).endCell()
        );
        let state_init_packed = packStateInit(ProposalInit{master: myAddress(), proposalId: id}.toCell());
        sendRawMessag(
        //           dark magic here
            beginCell()
            .storeUint(((0x10) << 11) + 1024, 6 + 11)
            .storeUint(state_init_packed.hash(), 256)
            .storeUint(((MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0) << 32) + msg.votingEndingAt, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4 + 32)
            .storeRef(state_init_packed)
            .endCell(),
            SendRemainingValue
        );
        commit();
        throw(0);

    }
    get fun nextProposalId(): Int {
        let d = getData().asSlice();
        return bool(d.bits()) ? d.loadUint(10) : 0;
    }
}

message Vote {
    value: Bool;
}

struct ProposalState {
    yesCount: Int as uint32;
    noCount: Int as uint32;
    master: Address;
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32;
}

contract Proposal(data: ProposalInit) {

    receive(m: Slice){
        nativeThrowUnless(2025, sender() == self.data.master);
        setData(
            beginCell()
            .storeSlice(m)
            .storeUint(self.data.proposalId, 65 + 32)  // store uint32 + uint32 + dict(none)
            .storeAddress(self.data.master)
            .endCell()
        );
//        setCode(actual_code());
        commit();
        throw(0);
    }
    receive(msg: Vote) {
        // TODO: be in code
    }

    get(-14) fun proposalState(): ProposalState {
        let address: Address? = null;
        return ProposalState{
            yesCount: 0,
            noCount: 0,
            master: address!!,
            proposalId: 0,
            votingEndingAt: 0
        };
    }
    get(-124) fun asm_fun_callt(){
        vzlom_zopi();
    }
}

asm fun sendRawMessag(msg: Cell, flags: Int) {SENDRAWMSG}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
asm fun getData(): Cell { c4 PUSH }
asm extends fun storeDict(self: Builder, dict: Cell): Builder {
    SWAP STDICT
}
asm fun bool(c: Int): Bool {  }

asm inline fun vzlom_zopi() {
    1000 constant //a
    //a drop main PROC:<{ DUMPSTK }> %proposalState PROC:<{ DUMPSTK }>  __tact_selector_hack PROC:<{ DUMPSTK }> %asm_fun_callt PROC:<{ DUMPSTK }> }> }END>c drop
    B{b5ee9c724101040100bd0003fa8f7a20d749c3218e3301d07481010bd724ed44d081010bd7185121c705f2e7e901d70b057003d70b1fc8cb1f13cb3f7001ca0012cb0501cf16c9ed54e001d0ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e573f4048b0804d71d7c4404807df41af2d4dd038020d721d70b00e302d35f30a4c8e1010203002cd33f01a4c8cb3f01d71d1fcf1612f40001cf16c9ed540016cb5f12f40001cf16c9ed540028ed44d0d31fd31fd31f71d721d305fa4030015503a116e9df} B>boc                  
    dup hashB B>X $>B "hex" B>file
    2 boc+>B dup
    "res" B>file
    B>base64 $>B "boc" B>file
    bye
}
asm fun proposalCode(): Cell {
    B{b5ee9c724101040100bd0003fa8f7a20d749c3218e3301d07481010bd724ed44d081010bd7185121c705f2e7e901d70b057003d70b1fc8cb1f13cb3f7001ca0012cb0501cf16c9ed54e001d0ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e573f4048b0804d71d7c4404807df41af2d4dd038020d721d70b00e302d35f30a4c8e1010203002cd33f01a4c8cb3f01d71d1fcf1612f40001cf16c9ed540016cb5f12f40001cf16c9ed540028ed44d0d31fd31fd31f71d721d305fa4030015503a116e9df} B>boc    PUSHREF
}