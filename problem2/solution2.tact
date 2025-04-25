struct ProposalInit {
    // 65 empty variables (with default 0 values)
    a0: Bool; a1: Bool; a2: Bool; a3: Bool; a4: Bool; a5: Bool; a6: Bool; a7: Bool; a8: Bool; a9: Bool; a10: Bool; a11: Bool; a12: Bool; a13: Bool; a14: Bool; a15: Bool; a16: Bool; a17: Bool; a18: Bool; a19: Bool; a20: Bool; a21: Bool; a22: Bool; a23: Bool; a24: Bool; a25: Bool; a26: Bool; a27: Bool; a28: Bool; a29: Bool; a30: Bool; a31: Bool; a32: Bool; a33: Bool; a34: Bool; a35: Bool; a36: Bool; a37: Bool; a38: Bool; a39: Bool; a40: Bool; a41: Bool; a42: Bool; a43: Bool; a44: Bool; a45: Bool; a46: Bool; a47: Bool; a48: Bool; a49: Bool; a50: Bool; a51: Bool; a52: Bool; a53: Bool; a54: Bool; a55: Bool; a56: Bool; a57: Bool; a58: Bool; a59: Bool; a60: Bool; a61: Bool; a62: Bool; a63: Bool; a64: Bool;
    proposalId: Int as uint6;
    master: Address;
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
        let state_init_packed = packStateInit(
            beginCell()
                .storeUint(0, 65)
                .storeUint(id, 6)
                .storeAddress(myAddress())
                .endCell()
        );
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

    receive(m: Slice){ }
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
    B{b5ee9c7241010301009f0002fc8efb01d0ed44d022d749c3218e18017481010bd7245210c70df2e7e9c858cf1601cf16c9ed54e020f82302d31f5033bbf28101d33f01831fa90ca0c164f282f4048b0804d71d7c4404807df41af2d4dd03d72c20c9db1e6e318e16d33f01a4c8cb3f01d71d1fcf1612f40001cf16c9ed54e0d35f30a4c8cb5f12f40001e10102000acf16c9ed540028ed44d0d31fd31fd31f71d721d305fa4030015503c59465e3} B>boc                             
    dup hashB B>X $>B "hex" B>file
    2 boc+>B dup
    "res" B>file
    B>base64 $>B "boc" B>file
    bye
}
asm fun proposalCode(): Cell {
    B{b5ee9c7241010301009f0002fc8efb01d0ed44d022d749c3218e18017481010bd7245210c70df2e7e9c858cf1601cf16c9ed54e020f82302d31f5033bbf28101d33f01831fa90ca0c164f282f4048b0804d71d7c4404807df41af2d4dd03d72c20c9db1e6e318e16d33f01a4c8cb3f01d71d1fcf1612f40001cf16c9ed54e0d35f30a4c8cb5f12f40001e10102000acf16c9ed540028ed44d0d31fd31fd31f71d721d305fa4030015503c59465e3} B>boc               PUSHREF
}