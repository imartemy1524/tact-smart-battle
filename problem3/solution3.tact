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
// bcs tact has bad perfomance - lets replace current code with func one
// #include "./imports/stdlib.fc";
//#include "_compiled_code.fc";
//(slice, int) check_if_opcode$1(slice input) asm "x{00000001} SDBEGINSQ";
//(slice, int) check_if_opcode$193b63cd(slice input) asm "x{193b63cd} SDBEGINSQ";
//
//cell child_state_init(slice owner) inline {
//    return begin_cell()
//        .store_uint(6, 5)
//        .store_ref(get_child_code())
//        .store_ref(
//            begin_cell()
//                .store_slice(my_address())
//                .store_slice(owner)
//                .end_cell()
//        )
//        .end_cell();
//}
//;; slice calculate_child_address(cell state_init) inline {
//;;     return begin_cell().store_uint(1024, 11)
//;;         .store_uint(cell_hash(state_init), 256)
//;;         .end_cell()
//;;         .begin_parse();
//;; }
//
//() deploy_child(slice sender_address, int value) impure inline {
//    cell state_init = child_state_init(sender_address);
//    cell message = begin_cell()
//        .store_uint((BOUNCEABLE << 11) + 1024, 6 + 11)
//        .store_uint(cell_hash(state_init), 256)
//    ;; .store_slice(calculate_child_address(state_init))
//        .store_uint(((MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0) << 1) + value, MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4 + 1)
//        .store_ref(state_init)
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
//    in_msg_body~skip_op();
//
//    if (flags & 1) {
//        slice data = get_data().begin_parse();
//        int istrue = in_msg_body~load_bool();
//        if (istrue) {
//            set_data(
//                begin_cell()
//                .store_uint(data~load_uint(64) - 1, 64)
//                .store_slice(data)
//                .end_cell()
//            );
//            ;; save_data(votingUntil, yescount - 1, nocount);
//        }
//        else {
//            set_data(
//                begin_cell()
//                    .store_uint(data~load_uint(64 + 32) - 1, 64 + 32)
//                    .end_cell()
//            );
//            ;; save_data(votingUntil, yescount, nocount - 1);
//        }
//        return ();
//    }
//    ;; elseif (in_msg_body~check_if_opcode$193b63cd()) {
//    slice sender_address = cs~load_msg_addr();
//    slice data = get_data().begin_parse();
//    slice data2 = data;
//    throw_unless(1394, now() <= data~load_uint(32));
//    int value = in_msg_body~load_uint(1);
//    if (value) {
//        int a = data2~load_uint(64) + 1;
//        set_data(
//                begin_cell()
//                    .store_uint(a, 64)
//                    .store_slice(data2)
//                    .end_cell()
//        );
//;;            save_data(votingUntil, yescount + 1, nocount);
//    }
//    else {
//        set_data(
//            begin_cell()
//                .store_uint(data2~load_uint(64 + 32) + 1, 64 + 32)
//                .end_cell()
//        );
//      ;;  save_data(votingUntil, yescount, nocount + 1);
//    }
//    deploy_child(sender_address, value);
//
//}
//
//_ proposalState() method_id {
//    slice s = get_data().begin_parse();
//    s~skip_bits(32);
//
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
asm fun actual_code(): Cell { B{b5ee9c724101060100e50002f8ff00208eee3020c700915be001d0d30301028020d7210271b08e2330ed44d001d20001319dd33f01a5c8cb3f01cf16c9ed549ad35f30a5c8cb5fc9ed54e2e0fa4030ed44d020f82302d31f3012bbf2e57202d30030209e02d33f01a4c8cb3f01cf16c9ed549b02d35f30a4c8cb5fc9ed54e201e1f4a413f4bcf2c80b0105015201c8f828cf1601cf16c98876c8cb04ccccc901a60c21f9008200c400c8cb10cbffcb70ccc98040fb00020114ff00f4a413f4bcf2c80b030128d330d0d3030130fa4030ed44d001d7263088ed5404000120001fa64e58bb5134200835c874c7f4c7cc206f36e323} B>boc PUSHREF }


// and sources of child contract code
// #include "imports/stdlib.fc";
//(slice, ()) check_if_starts_with(slice input, slice starts_with) impure asm "SDBEGINSX";
//
//() recv_internal(cell in_msg_full, slice in_msg_body) impure {
//    slice cs = in_msg_full.begin_parse();
//    int flags = cs~load_msg_flags();
//    slice sender_address = cs~load_msg_addr();
//    slice data_getter = get_data().begin_parse();
//    data_getter~check_if_starts_with(sender_address);
//    set_data(
//        address_none_cell()
//    );
//
//}