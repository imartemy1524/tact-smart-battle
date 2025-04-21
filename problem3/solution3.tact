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

asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
// bcs tact has bad perfomance - lets replace current code with func one
// #include "./imports/stdlib.fc";
//#include "_compiled_code.fc";
//(slice, int) check_if_opcode$1(slice input) asm "x{00000001} SDBEGINSQ";
//(slice, int) check_if_opcode$193b63cd(slice input) asm "x{193b63cd} SDBEGINSQ";
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
//    return begin_cell().store_uint(4, 3)
//        .store_int(0, 8)
//        .store_uint(cell_hash(state_init), 256)
//        .end_cell()
//        .begin_parse();
//}
//
//() deploy_child(slice sender_address, int value) impure inline {
//    cell state_init = child_state_init(sender_address);
//    cell message = begin_cell()
//        .store_uint(BOUNCEABLE, 6)
//        .store_slice(calculate_child_address(state_init))
//        .store_uint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4)
//        .store_ref(state_init)
//        .store_bool(value)
//        .end_cell();
//    send_raw_message(message, SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE);
//
//}
//
//() recv_internal(cell in_msg_full, slice in_msg_body) impure {
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
//    elseif (in_msg_body~check_if_opcode$193b63cd()) {
//        slice sender_address = cs~load_msg_addr();
//        throw_unless(1394, now() <= votingUntil);
//        int value = in_msg_body~load_int(1);
//        if (value) {
//            yescount += 1;
//        } else {
//            nocount += 1;
//        }
//        save_data(votingUntil, yescount, nocount);
//        deploy_child(sender_address, value);
//    }
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
// compiled to cell
asm fun actual_code(): Cell { B{b5ee9c724102060100010d0003a2ff00208f433020c700915be001d0d30301db3c0371b08e1e33038020d721d200019202a59301a558e202d102c8cb1fcb1fcb1fc9ed54e004d72c20c9db1e6c965f05840ff2f0e30de1f4a413f4bcf2c80b05010401ba03fa4030f82322bbf2e57203d20030209204a49402a44014e25802c8cb1fcb1fcb1fc9ed54010170c8f828cf1658cf16c98822c8cb01f400f400cb00c9768018c8cb0522f9008309c8cb0acbffc9d0cf16cb6fcc0101ca00c98040fb00020114ff00f4a413f4bcf2c80b030062d3c7009130e0d0d3030171b09130e0fa4030ed44d0fa405112c705f2e3e7d70b01c000f2d4bcc801cf167001cb01c9ed54010fa64e58b6cf1b04a0050014ed44d0d31fd31fd31fd1d43ef446} B>boc PUSHREF }


// and sources of child contract code
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
//    ;; check that sender is master
//    throw_unless(999, equal_slices_bits(data_getter~load_msg_addr(), sender_address));
//    ;; check if already voted
//    throw_if(1212, is_address_none(data_getter));
//    set_data(
//        begin_cell()
//            .store_slice(sender_address)
//            .store_address_none() ;; store the status as null address
//            .end_cell()
//    );
//
//}