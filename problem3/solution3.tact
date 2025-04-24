message Vote { value: Bool;}
struct Answer {
    //    data: Int;
    exitCode: Int;
    data: Cell;
    c5: Cell;
}
struct ProposalState { yesCount: Int as uint32;noCount: Int as uint32;}
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32;}
message(0x1234) OnError{ owner: Address; vote: Bool;}
inline fun child_state_init(): Cell {
    return beginCell()
        .storeUint(6, 5)
        .storeRef(get_child_code())
        .storeRef(
            beginCell()
            .storeAddress(myAddress())
            .storeUint(0, 1)
            .endCell()
        )
        .endCell();
}
const MSG_INFO_REST_BITS: Int = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE: Int = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT: Int = 4;
const MSG_STATE_INIT_IN_REF: Int = 2;
const MSG_BODY_IN_REF: Int = 1;

struct A{ a: Cell; b: Builder }
inline fun deploy_child_msg(): A  {
    let state_init: Cell = child_state_init();
    let a: Builder = beginCell()
        .storeUint((0x18), 6)
        .storeUint(1024, 11)
        .storeUint((state_init.hash()), 256);
    let b = a;
    let msgToDeploy = a
        .storeUint(((MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + 0)), MSG_WITH_STATE_INIT_AND_BODY_SIZE + 4)
        .storeRef(state_init);

    return A{
        a: msgToDeploy.endCell(),
        b: b.storeUint(0, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + 0)
    }
}


contract Proposal(data: Init) {

    receive(){throw(0);}

    receive(msg: Vote) {
        let addr = deploy_child_msg();
        let data = beginCell()
              .storeUint(self.data.votingEndingAt << 64, 32 + 64)
              .storeRef(addr.a)
              .storeBuilder(addr.b)
              .endCell();

        let ans = runvm(
            // my_balance
            myBalance(),
            // ton_amount
            context().value,
            // original_message
            beginCell().storeUint(0, 4).storeAddress(sender()).storeSlice(context().raw).endCell(),
            msg.toCell().beginParse(),
            0,
            5,
            actual_code().beginParse(),
            data,
            get_c7()
        );
        set_actions(ans.c5);
        set_data(ans.data);

        setCode(actual_code());
        commit();
        throw(ans.exitCode);
    }

    get fun proposalState(): ProposalState { return ProposalState{yesCount: 0, noCount: 0};}

}

asm fun send_raw_message(msg: Cell, flags: Int) { SENDRAWMSG }
asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
asm fun actual_code(): Cell { B{b5ee9c724101040100d200021aff0020e303f4a413f4bcf2c80b010301f63001d0d3030101fa403002d31f01300171b08e2631d2000131ed44d0019dd33f01a5c8cb3f01cf16c9ed549dd35f01a5c8cb5f01cf16c9ed54e2e0ed44d020f82302d31f5033bbf2e57222d3003021d74a9401d43101de9dd33f01a4c8cb3f01cf16c9ed549dd35f01a4c8cb5f01cf16c9ed54e202fa443122d74a02005e9f8b64465706c6f798fe203002d430d09d8b36765748fe2030028040d721e202c85003cf1601cf16cbffc98040fb00001fa64e58bb5134200835c874c7f4c7cc208c512570} B>boc PUSHREF }
asm fun get_child_code(): Cell { B{b5ee9c72410103010041000114ff00f4a413f4bcf2c80b01015ed301d0d3030130fa4030ed44d021d726f404300271d7218801d3ff3055028307f46f6ef2e575c858cf16f400c9ed54020000ca8ea78f}  B>boc PUSHREF }
asm fun get_data(): Cell{ c4 PUSH }
asm fun set_data(data: Cell) { c4 POP }
asm fun set_actions(actions: Cell) { c5 POP }
asm fun get_c7(): Cell { c7 PUSHCTR }


asm fun runvm(balance: Int, ton_amount: Int, in_msg_full: Cell, in_msg_body: Slice, method__id: Int,  argscount_before_this_arg_args_1: Int, master_code: Slice, master_data: Cell, c7: Cell): Answer {
53 RUNVM
}



