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
    .storeRef(init.data);

}
inline fun contractAddressPacked(packed: Cell): Slice{
    return beginCell()
    .storeUint(1024, 11)
    .storeUint(packed.hash(), 256)
    .endCell()
    .beginParse()
}

contract ProposalMaster {
    id: Int as uint32 = 0;
    // top up
    receive() {
        if(context().value > ton("0.01")){
            nativeReserve(ton("0.01"), ReserveAtMost);
            send(SendParameters{
                to: sender(),
                value: 0,
                bounce: false,
                mode: SendRemainingBalance
            })
        }
    }

    receive(msg: DeployNewProposal) {
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let state = initOf Proposal(ProposalInit{master: myAddress(), proposalId: self.id});
        self.id += 1;
        let state_init_packed = packStateInit(state);
        let addr = contractAddressPacked(state_init_packed);
        sendRawMessag(
            beginCell()
                .storeUint(0x10, 6)
                .storeSlice(addr)
                .storeUint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4)
                .storeRef(state_init_packed)
                .storeUint(msg.votingEndingAt, 32)
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
    votingEndingAt: Int as uint32 = 0;
    yesCount: Int as uint32 = 0;
    noCount: Int as uint32 = 0;
    master: Address;
    proposalId: Int as uint32;
    dictWithData: Bool = false;
    init(data: ProposalInit){
        self.master = data.master;
        self.proposalId = data.proposalId;
    }

    receive(m: Slice){
        nativeThrowUnless(2025, sender() == self.master);
        setData(
        beginCell()
            .storeSlice(m)
            .storeUint(0, 64)
            .storeAddress(self.master)
            .storeUint(self.proposalId, 32)
            .storeBit(false)
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
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
asm extends fun storeDict(self: Builder, dict: Cell): Builder { SWAP STDICT }

asm fun sendRawMessag(msg: Cell, flags: Int) { SENDRAWMSG }

// source code (func):
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
//(int, int, int, slice, int, cell) load_data(int load_dictt) inline {
//    cell data = get_data();
//    var cs = data.begin_parse();
//
//    int votingEndingAt = cs~load_uint(32);
//    int yesCount = cs~load_uint(32);
//    int noCount = cs~load_uint(32);
//    slice master = cs~load_msg_addr();
//    int proposalId = cs~load_uint(32);
//    cell dict = load_dictt ? cs~load_dict() : null();
//    return (votingEndingAt, yesCount, noCount, master, proposalId, dict);
//}
//() save_data(int votingUntil, int yescount, int nocount, slice master, int proposalId, cell dict) impure inline {
//    set_data(
//        begin_cell()
//            .store_uint(votingUntil, 32)
//            .store_uint(yescount, 32)
//            .store_uint(nocount, 32)
//            .store_slice(master)
//            .store_uint(proposalId, 32)
//            .store_dict(dict)
//            .end_cell()
//    );
//}
//() recv_internal(int value, cell in_msg_full, slice in_msg_body) impure {
//    slice cs = in_msg_full.begin_parse();
//    int flags = cs~load_msg_flags();
//    if (flags & 1) {
//        ;; ignore all bounced messages
//        return ();
//    }
//    slice sender_address = cs~load_msg_addr();
//    if (in_msg_body.slice_empty?()) {
//        ;; ignore empty messages
//        return ();
//    }
//    (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId, cell dict) = load_data(1);
//    if (in_msg_body~check_if_opcode$193b63cd()) {
//        throw_unless(1394, now() <= votingEndsAt);
//        throw_unless(1395, yes_count + no_count < 100);
//        (int chain, int address) = parse_std_addr(sender_address);
//        ;; force 0 chain
//        throw_if(1396, chain);
//        (cell _tt, int found) = dict.udict_get_ref?(256, address);
//        throw_if(1397, found);
//        dict~udict_set_ref(256, address, empty_cell());
//
//        int value = in_msg_body~load_int(1);
//        if (value) {
//            yes_count += 1;
//        } else {
//            no_count += 1;
//        }
//        save_data(
//            votingEndsAt,
//            yes_count,
//            no_count,
//            master,
//            proposalId,
//            dict
//        );
//        reply_msg(sender_address, "ok"u, 8 * 2);
//    }
//    else {
//        throw(0xffff);
//    }
//
//}
//
//_ proposalState() method_id {
//    (int votingEndsAt, int yes_count, int no_count, slice master, int proposalId, cell dict) = load_data(0);
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
asm fun actual_code(): Cell { B{b5ee9c724101040100ea0002a2ff00208ec33032d0d3030171b0915be0fa403021c700915be071ed44d0d31fd31fd31ffa40d31f069405f4043092356de210451034413007d72c20c9db1e6c965f08840ff2f0e30de1f4a413f4bcf2c80b010301d2f82326bbf2e5725343a0c164f2e57326fa4401f2d57453088307f40f6fa131f2d5758840198307f41707d200309203a49402a44013e20405413605c8cb1f14cb1f12cb1f01cf16cb1ff400c9ed54816f6b80108010c8cb055003cf1602a620a66f12cf01c98042fb000200000049a64e589c3b513434c7f4c7f4c7fe9034c7c1a5017d010c248d5b788411440d104c0c1540e0679346de} B>boc PUSHREF }
