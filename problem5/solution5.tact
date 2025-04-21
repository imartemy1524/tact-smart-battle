message Vote { value: Bool;}
struct ProposalState { yesCount: Int as uint32;noCount: Int as uint32;}
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32;}
message(0x1234) OnError{ owner: Address; vote: Bool;}

contract Proposal {

    init(data: Init) {
        setData(
        beginCell()
        .storeUint(data.votingEndingAt, 32)
        .storeUint(0, 64)
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


// source code for main contract
// #include "./imports/stdlib.fc";
//#include "_compiled_code.fc";
//(slice, int) check_if_opcode$1(slice input) asm "x{00000001} SDBEGINSQ";
//(slice, int) check_if_opcode$193b63cd(slice input) asm "x{193b63cd} SDBEGINSQ";
//const const::min_amount = 30000000; ;; 0.03 ton
//
//(int, int, int) load_data() inline_ref {
//    cell data = get_data();
//    var cs = data.begin_parse();
//    int votingEndingAt = cs~load_uint(32);
//    int yesCount = cs~load_uint(32);
//    int noCount = cs~load_uint(32);
//    cs.end_parse();
//    return (votingEndingAt, yesCount, noCount);
//}
//() save_data(int votingUntil, int yescount, int nocount) impure inline {
//    set_data(
//        begin_cell()
//            .store_uint(votingUntil, 32)
//            .store_uint(yescount, 32)
//            .store_uint(nocount, 32)
//            .end_cell()
//    );
//}
//() reply_msg(slice to, int message, int length) impure inline {
//    cell msg2sender = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(to)
//        .store_uint(message, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + length)) ;; 32 bits empty (comment padding) and length - length of comment
//        .end_cell();
//    send_raw_message(msg2sender, SEND_MODE_IGNORE_ERRORS | SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//}
//
//cell child_state_init(slice owner) inline {
//    return begin_cell()
//        .store_uint(0, 2)
//        .store_dict(get_child_code())
//        .store_dict(
//            begin_cell()
//                .store_slice(my_address())
//                .store_slice(owner)
//                .end_cell()
//        )
//        .store_uint(0, 1)
//        .end_cell();
//}
//slice calculate_child_address(cell state_init) inline {
//    return begin_cell().store_uint(1024, 11)
//        .store_uint(cell_hash(state_init), 256)
//        .end_cell()
//        .begin_parse();
//}
//
//() deploy_child(slice sender_address, int value) impure inline {
//    cell state_init = child_state_init(sender_address);
//    cell message = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(calculate_child_address(state_init))
//        .store_uint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4)
//        .store_ref(state_init)
//        .store_bool(value)
//        .end_cell();
//    send_raw_message(message, SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//
//}
//
//() recv_internal(int ton_amount, cell in_msg_full, slice in_msg_body) impure {
//    if (in_msg_body.slice_empty?()) {
//        ;; ignore all empty messages
//        return ();
//    }
//    slice cs = in_msg_full.begin_parse();
//    int flags = cs~load_msg_flags();
//    (int votingUntil, int yescount, int nocount) = load_data();
//    if (flags & 1) {
//        in_msg_body~skip_bounced_prefix();
//        int istrue = in_msg_body~load_bool();
//        if (istrue) {
//            yescount -= 1;
//        } else {
//            nocount -= 1;
//        }
//        in_msg_body.end_parse();
//        save_data(votingUntil, yescount, nocount);
//        return ();
//    }
//    slice sender_address = cs~load_msg_addr();
//
//    if (in_msg_body~check_if_opcode$193b63cd()) {
//        throw_unless(1394, now() <= votingUntil);
//        throw_unless(135, ton_amount >= const::min_amount);
//        int value = in_msg_body~load_int(1);
//        if (value) {
//            yescount += 1;
//        } else {
//            nocount += 1;
//        }
//        save_data(votingUntil, yescount, nocount);
//        deploy_child(sender_address, value);
//    }
//    ;; elseif (in_msg_body~check_if_opcode$1()) {
//    ;;     slice owner = in_msg_body~load_msg_addr();
//    ;;     throw_unless(1342, equal_slices_bits(sender_address, calculate_child_address(child_state_init(owner))));
//    ;;     int istrue = in_msg_body~load_bool();
//    ;;     if (istrue) {
//    ;;         yescount -= 1;
//    ;;     } else {
//    ;;         nocount -= 1;
//    ;;     }
//    ;;     save_data(votingUntil, yescount, nocount);
//    ;;     reply_msg(owner, "error"u, 5 * 8);
//    ;; }
//    else {
//        throw(0xffff);
//    }
//
//}
//
//_ proposalState() method_id {
//    (int _aa, int yes_count, int no_count) = load_data();
//    return (yes_count, no_count);
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
asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
asm fun actual_code(): Cell { B{b5ee9c72410208010001b3000450ff00208fa23020c700925f03e001d0d3030171b0925f03e0fa4030db3c04d72c20c9db1e6ce30fe10701020501caf82323bbf2e57205821005f5e100bef2e08704d20030209204a49403a40304e2550202c8cb1fcb1fcb1fc9ed54010170c8f828cf1658cf16c98822c8cb01f400f400cb00c9768010c8cb0522f9008309c8cb0acbffc9d0cf16cb6fcc0101ca00c98040fb000301ee3504d72c200000000c8ee4fa402170c8f828cf1658cf16c98822c8cb01f400f400cb00c9f9008309c8cb0acbffc9d014c705f2e53e02d20001319203a59402a54013e2430302c8cb1fcb1fcb1fc9ed5482186572726f7280288010c8cb055003cf1602a620a66f12cf01c98042fb00965f05840ff2f0e2030114ff00f4a413f4bcf2c80b0400e4d320c700915be001d0d3030171b0915be0fa4030ed44d020fa405113c705f2e3e7fa40c7008e296c227fc85003cf1612ca00c9ed54816f6b80108010c8cb055003cf1602a620a66f12cf01c98042fb008e1f3158718010c8cb055004cf1613cb8e01cf1601cf16c98042fb00f80ff2c4bce20110f4a413f4bcf2c80b06010fa64e58b6cf1b04a0070014ed44d0d31fd31fd31fd1f65bab38} B>boc PUSHREF }

// source code for child contract
// #include "imports/stdlib.fc";
//
//() reply(slice to, slice owner, slice message) impure inline {
//    cell msg2sender = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(to)
//        .store_uint(1, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32)) ;; op code 1
//        .store_slice(owner) ;; owner address
//        .store_slice(message) ;; the bit, describing minus or plus
//        .end_cell();
//    send_raw_message(msg2sender, SEND_MODE_IGNORE_ERRORS | SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//}
//() reply_msg(slice to, int message, int length) impure inline {
//    cell msg2sender = begin_cell()
//        .store_uint(0x10, 6)
//        .store_slice(to)
//        .store_uint(message, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + length)) ;; 32 bits empty (comment padding) and length - length of comment
//        .end_cell();
//    send_raw_message(msg2sender, SEND_MODE_IGNORE_ERRORS | SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//}
//
//() recv_internal(cell in_msg_full, slice in_msg_body) impure {
//    if (in_msg_body.slice_empty?()) {
//        ;; ignore all empty messages
//        return ();
//    }
//    slice cs = in_msg_full.begin_parse();
//    int flags = cs~load_msg_flags();
//    if (flags & 1) {
//        ;; ignore all bounced messages
//        return ();
//    }
//    slice sender_address = cs~load_msg_addr();
//    cell data = get_data();
//    slice data_getter = data.begin_parse();
//    slice data_original = data_getter;
//    ;; check that sender is master
//    throw_unless(999, equal_slices_bits(data_getter~load_msg_addr(), sender_address));
//    ;; now data_getter contains onwer address; one bit
//    slice owner_address = data_getter~load_msg_addr();
//    ifnot (slice_empty?(data_getter)) {
//        throw(1001);
//        ;; already deployed, throw message back
//;;        reply(sender_address, owner_address, in_msg_body);
//;;        commit();
//;;        throw(1212);
//    }
//    else {
//        set_data(
//            begin_cell()
//                .store_slice(data_original)
//                .store_int(TRUE, 1) ;; store the bit
//                .end_cell()
//        );
//        reply_msg(owner_address, "ok"u, 2 * 8);
//    }
//}