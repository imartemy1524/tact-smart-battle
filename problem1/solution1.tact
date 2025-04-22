
message Vote {
    value: Bool;
}

struct ProposalState {
    yesCount: Int as uint32;
    noCount: Int as uint32;
}

struct Init {
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32;
}

contract Proposal {
    init(data: Init) {
        setData(
            beginCell()
                .storeUint((data.votingEndingAt << 65), 32 + 65)
                .endCell()
        );
        setCode(actual_code());
        commit();
        throw(0);
    }
    receive(){}
    receive(msg: Vote) {
    }

    get fun proposalState(): ProposalState {
        return ProposalState{
            yesCount: 0,
            noCount: 0
        };
    }

}
const SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE: Int = 64;


asm extends fun add(self: ProposalState): Int { ADD }
asm fun inc(s: Int): Int { INC }
asm fun sendRawMessag(msg: Cell, flags: Int) {
    SENDRAWMSG
}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
struct Addr{
    chain: Int;
    hash: Int;
}
asm fun parse_std_addr(s: Address): Addr {
    REWRITESTDADDR
}
// #include "./imports/stdlib.fc";
//(slice, int) check_if_0(slice input) asm "<b 0 1 u, b> <s SDBEGINSQ";
//
//() reply_msg(slice to, int message, int length) impure inline {
//    cell msg2sender = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(to)
//        .store_uint(message, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + length)) ;; 32 bits empty (comment padding) and length - length of comment
//        .end_cell();
//    send_raw_message(msg2sender, SEND_MODE_IGNORE_ERRORS | SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//}
//int inc(int v) asm "INC";
//;;; adds 2 uin64 (containing 2 uint32)
//int sum2hack(int a, int b) asm "DIVMOD ADD";
//() recv_internal(cell in_msg_full, slice in_msg_body) impure {
//    slice cs = in_msg_full.begin_parse();
//    cs~load_msg_flags();
//    ;; if (flags & 1) {
//    ;;     ;; ignore all bounced messages
//    ;;     return ();
//    ;; }
//    slice sender_address = cs~load_msg_addr();
//    ;; if (in_msg_body.slice_empty?()) {
//    ;;     ;; ignore empty messages
//    ;;     return ();
//    ;; }
//    in_msg_body~skip_op();
//    cell data = get_data();
//    slice cs = data.begin_parse();
//    slice cs0 = cs;
//    ;; (int votingEndsAt, int yes_count, int no_count, cell dict) = load_data(1);
//    throw_unless(1394, now() <= cs~load_uint(32));
//    throw_unless(1395, sum2hack(cs~load_uint(64), 1 << 32) < 100);
//    (int chain, int address) = parse_std_addr(sender_address);
//    cell dict = cs~load_dict();
//    dict~udict_set_ref(256, address, empty_cell());
//    ifnot (in_msg_body~check_if_0()) {
//        int b = inc(cs0~load_uint(64));
//        set_data(
//            begin_cell()
//                .store_uint(b, 64)
//                .store_slice(cs0~load_bits(32))
//                .store_dict(dict)
//            .end_cell()
//        );
//
//    }
//    else {
//        var a = cs0~load_uint(64 + 32);
//        set_data(
//            begin_cell()
//            .store_uint(inc(a), 64 + 32)
//            .store_dict(dict)
//            .end_cell()
//        );
//    }
//    reply_msg(sender_address, "ok"u, 8 * 2);
//
//
//}
//
//_ proposalState() method_id {
//    slice s = get_data().begin_parse();
//    s~skip_bits(32);
//    return (
//        s~load_uint(32),
//        s~load_uint(32)
//    );
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
asm fun actual_code(): Cell { B{b5ee9c724101040100a400021aff0020e303f4a413f4bcf2c80b010301f83001d0d3030130fa4030018020d721ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e57323fa443101f4043088598307f41702d20001319cd35f30a4c8cb5ff400c9ed548e12d33f01a4c8cb3f01d61f30cf16f400c9ed54e2816f6b80108010c8cb055003cf1602a620a66f12cf01c98042fb00020000001fa64e58bb5134200835c874c7f4c7cc20d827e558} B>boc PUSHREF }
