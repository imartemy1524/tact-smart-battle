struct ProposalInit {
    master: Address;
    proposalId: Int as uint32;
}

message DeployNewProposal {
    votingEndingAt: Int as uint32;
}
inline fun packStateInit(init: StateInit): Cell{
    return beginCell()
    .storeUint(0b110, 5)
    .storeRef(init.code)
    .storeRef(init.data)
    .endCell();

}
inline fun replyOk(to: Address) {
    let msg2sender = beginCell()
    .storeUint(0x10, 6)
    .storeAddress(to)
    .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
    .endCell();
    sendRawMessag(msg2sender, SendRemainingValue);
}
const MSG_INFO_REST_BITS: Int = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE: Int = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT: Int = 4;
const MSG_STATE_INIT_IN_REF: Int = 2;
const MSG_BODY_IN_REF: Int = 1;

inline fun contractAddressPacked(packed: Cell): Builder{
    return beginCell()

}
contract ProposalMaster {
    id: Int as uint32 = 0;
    // deploy
    receive() { }

    receive(msg: DeployNewProposal) {
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let state = initOf Proposal(ProposalInit{master: myAddress(), proposalId: self.id});
        self.id += 1;
        let state_init_packed = packStateInit(state);
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

    }
    get fun nextProposalId(): Int {
        return self.id;
    }
}

// ==============================================================================

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

contract Proposal {
    master: Address;
    proposalId: Int as uint32;
    init(data: ProposalInit){
        self.master = data.master;
        self.proposalId = data.proposalId;
    }

    receive(m: Slice){
        nativeThrowUnless(2025, sender() == self.master);
        setData(
            beginCell()
            .storeSlice(m)
            .storeUint(0, 65)  // store uint32 + uint32 + dict(none)
            .storeAddress(self.master)
            .storeUint(self.proposalId, 32)
            .endCell()
        );
        setCode(actual_code());
        commit();
        throw(0);
    }
    receive(msg: Vote) {
        // TODO: be in code
    }

    get fun proposalState(): ProposalState {
        let address: Address? = null;
        return ProposalState{
            yesCount: 0,
            noCount: 0,
            master: address!!,
            proposalId: 0,
            votingEndingAt: 0
        };
    }
}

asm fun sendRawMessag(msg: Cell, flags: Int) {SENDRAWMSG}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
asm extends fun storeDict(self: Builder, dict: Cell): Builder {
    SWAP STDICT
}
// #include "./imports/stdlib.fc";
//(slice, int) check_if_opcode$193b63cd(slice input) asm "x{193b63cd} SDBEGINSQ";
//int sum2hack(int a, int b) asm "DIVMOD ADD";
//int inc(int a) asm "INC";
//
//(int, int, int, slice, int) load_data() inline {
//    cell data = get_data();
//    var cs = data.begin_parse();
//
//    int votingEndingAt = cs~load_uint(32);
//    int yesCount = cs~load_uint(32);
//    int noCount = cs~load_uint(32);
//    cs~skip_bits(1); ;; skip dict
//    slice master = cs~load_msg_addr();
//    int proposalId = cs~load_uint(32);
//    return (votingEndingAt, yesCount, noCount, master, proposalId);
//}
//() recv_internal(cell in_msg_full, slice in_msg_body) impure {
//    if (in_msg_body.slice_empty?()) {
//        ;; ignore all empty messages
//        return ();
//    }
//    in_msg_body~skip_op();
//    slice cs = in_msg_full.begin_parse();
//    int flags = cs~load_msg_flags();
//    slice sender_address = cs~load_msg_addr();
//    slice data = get_data().begin_parse();
//    slice data0 = data;
//    ;; (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId, cell dict) = load_data(1);
//
//    throw_unless(1394, now() <= data~load_uint(32));
//    throw_unless(1395, sum2hack(data~load_uint(64), 1 << 32) < 100);
//    (int chain, int address) = parse_std_addr(sender_address);
//    cell dict = data~load_dict();
//    cell prev = dict~udict_set_get_ref(256, address, empty_cell());
//    throw_unless(1397, cell_null?(prev));
//
//    int value = in_msg_body~load_int(1);
//    if (value) {
//        int a = inc(
//            data0~load_uint(64)
//        );
//        set_data(
//            begin_cell()
//            .store_uint(a, 64)
//            .store_slice(data0~load_bits(32))
//            .store_dict(dict)
//            .store_slice(data)
//            .end_cell()
//        );
//    } else {
//        int a = inc(
//            data0~load_uint(64 + 32)
//        );
//
//        set_data(
//            begin_cell()
//                .store_uint(a, 64 + 32)
//                .store_dict(dict)
//                .store_slice(data)
//                .end_cell()
//        );
//    }
//
//
//}
//
//_ proposalState() method_id {
//    (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId) = load_data();
//    return (yes_count, no_count, master, proposalId, votingEndsAt);
//}
//() __tact_selector_hack_asm() impure asm """
//@atend @ 1 {
//    execute current@ context@ current!
//    {
//        }END> b>
//
//        <{
//            SETCP0 DUP
//            IFNOTJMP:<{
//                DROP over <s ref@ 0 swap @procdictkeylen idict@ { "internal shortcut error" abort } ifnot @addop
//            }>
//swap <s ref@
//            0 swap @procdictkeylen idict- drop
//            -1 swap @procdictkeylen idict- drop
//            65535 swap @procdictkeylen idict- drop
//
//            @procdictkeylen DICTPUSHCONST DICTIGETJMPZ 11 THROWARG
//        }> b>
//    } : }END>c
//    current@ context! current!
//} does @atend !
//""";
//() __tact_selector_hack() method_id (65535) {
//    return __tact_selector_hack_asm();
//}
asm fun actual_code(): Cell { B{b5ee9c724101040100a20003faff00208ef23020c700915be08020d72101d0d3030130fa4030ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e57302fa443102f4048850428307f46f6ef2e57503d200308e16d33f01a4c8cb3f01d61f30cf1612f40001cf16c9ed548e10d35f30a4c8cb5f12f40001cf16c9ed54e2e1f4a413f4bc0102030000002da64e58bb513434c7f4c7f4c7dc75c87e9034c7cc1540e00006f2c80b7fd7354a} B>boc PUSHREF }
