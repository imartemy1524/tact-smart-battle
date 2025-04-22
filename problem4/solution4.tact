struct ProposalInit {
    master: Address;
    proposalId: Int as uint32;
}

message DeployNewProposal {
    votingEndingAt: Int as uint32;
}
const MSG_INFO_REST_BITS: Int = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE: Int = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT: Int = 4;
const MSG_STATE_INIT_IN_REF: Int = 2;
const MSG_BODY_IN_REF: Int = 1;

inline fun packStateInit(init: StateInit): Cell{
    return beginCell()
    .storeUint(0b110, 5)
    .storeRef(init.code)
    .storeRef(init.data)
    .endCell();

}


contract ProposalMaster {
    id: Int as uint32 = 0;
    // top up
    receive() {
        if(context().value > ton("0.01")){
            nativeReserve(ton("0.01"),  ReserveAddOriginalBalance);
            send(SendParameters{
                to: sender(),
                value: 0,
                bounce: false,
                mode: SendRemainingBalance | SendIgnoreErrors
            })
        }
    }

    receive(msg: DeployNewProposal) {
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let state = initOf Proposal(ProposalInit{master: myAddress(), proposalId: self.id});
        self.id += 1;
        let state_init_packed = packStateInit(state);
        sendRawMessag(
            beginCell()
                .storeRef(state_init_packed)
                .storeUint((0x10 << 11) + 1024, 6 + 11)
                .storeUint(state_init_packed.hash(), 256)
                .storeUint(((MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF ) << 32) + msg.votingEndingAt, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4 + 32)
                .storeAddress(sender())
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
inline fun replyOk(to: Slice) {
    let msg2sender = beginCell()
    .storeUint(0x10, 6)
    .storeSlice(to)
    .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
    .endCell();
    sendRawMessag(msg2sender, SendRemainingValue);
}

contract Proposal(data: ProposalInit) {

    receive(m: Slice){
        nativeThrowUnless(2025, sender() == self.data.master);
        setData(
            beginCell()
                .storeSlice(m.loadBits(32))
                .storeUint(0, 65)
                .storeAddress(self.data.master)
                .storeUint(self.data.proposalId, 32)
                .endCell()
        );
        replyOk(m);

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
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
asm extends fun storeDict(self: Builder, dict: Cell): Builder { SWAP STDICT }

asm fun sendRawMessag(msg: Cell, flags: Int) { SENDRAWMSG }

// #include "./imports/stdlib.fc";
//const const::min_amount = 10000000; ;; 0.01 ton
//(slice, int) check_if_opcode$193b63cd(slice input) asm "x{193b63cd} SDBEGINSQ";
//() reply_msg(slice to, int message, int length) impure inline {
//    cell msg2sender = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(to)
//        .store_uint(message, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + length)) ;; 32 bits empty (comment padding) and length - length of comment
//        .end_cell();
//    send_raw_message(msg2sender, SEND_MODE_IGNORE_ERRORS | SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//}
//
//(int, int, int, slice, int, cell) load_data() inline {
//    cell data = get_data();
//    var cs = data.begin_parse();
//
//    int votingEndingAt = cs~load_uint(32);
//    int yesCount = cs~load_uint(32);
//    int noCount = cs~load_uint(32);
//
//    cell dict = cs~load_dict();
//    slice master = cs~load_msg_addr();
//    int proposalId = cs~load_uint(32);
//    return (votingEndingAt, yesCount, noCount, master, proposalId, dict);
//}
//() recv_internal( cell in_msg_full, slice in_msg_body) impure {
//    slice cs = in_msg_full.begin_parse();
//    cs~load_msg_flags();
//    slice sender_address = cs~load_msg_addr();
//    ;; (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId, cell dict) = load_data();
//    ;; in_msg_body~skip_op();
//    if (in_msg_body~check_if_opcode$193b63cd()) {
//        slice data = get_data().begin_parse();
//        slice data_original = data;
//        throw_unless(1394, now() <= data~load_uint(32));
//        throw_unless(1395, data~load_uint(32) + data~load_uint(32) < 100);
//        (int chain, int address) = parse_std_addr(sender_address);
//        ;; force 0 chain
//        ;; throw_if(1396, chain);
//        cell dict = data~load_dict();
//        cell prev = dict~udict_set_get_ref(256, address, empty_cell());
//        throw_unless(1397, cell_null?(prev));
//        reply_msg(sender_address, "ok"u, 8 * 2);
//        int value = in_msg_body~load_int(1);
//        if (value) {
//
//            int b = data_original~load_uint(64) + 1;
//            int c = data_original~load_uint(32);
//            data_original~load_bool();
//            set_data(
//            begin_cell()
//                .store_uint(b, 64)
//                .store_uint(c, 32)
//                .store_dict(dict)
//                .store_slice(data_original)
//                .end_cell()
//            );
//
//        } else {
//            int a = data_original~load_uint(32 * 3) + 1;
//            data_original~load_bool();
//
//            set_data(
//                begin_cell()
//                    .store_uint(a, 64 + 32)
//                    .store_dict(dict)
//                    .store_slice(data_original)
//                    .end_cell()
//            );
//        }
//
//    }
//    else {
//        throw(0xffff);
//    }
//
//}
//
//_ proposalState() method_id {
//    (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId, cell dict) = load_data();
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
asm fun actual_code(): Cell { B{b5ee9c724101060100d000021aff0020e303f4a413f4bcf2c80b010503f83001d0d3030130fa403001d72c20c9db1e6c8f68ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e57323fa443101f4043088598307f46f6ef2e57503816f6b80108010c8cb055003cf1602a620a66f12cf01c98042fb0001d200308e15d35f01a401f4043101c8cb5f12f40001cf16c9ed54e30d02030400000032d33f01a401d31ff4043102c8cb3fcb1f12f40001cf16c9ed54000ce05b840ff2f0002da64e58bb513434c7f4c7f4c7fd010c7e9034c7cc1540e02c04c7e3} B>boc PUSHREF }
