message(1) Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint4;
    yesCount: Int as uint4;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint8;
    // proposal id is always 0 BTW
}

contract Proposal(data: Init) {
    receive() { }

    receive(msg: Vote) { }

    get(-14) fun proposalState(): ProposalState {
        return votes();
    }
    get fun aaa(){

        asm_fun_call();
    }
}
asm fun votes(): ProposalState {}
asm fun setCode(code: Cell) {SETCODE}




asm inline fun asm_fun_call() {
1000 constant //a
//a drop main PROC:<{ DUMPSTK }> %proposalState PROC:<{ DUMPSTK }>  __tact_selector_hack PROC:<{ DUMPSTK }> %aaa PROC:<{ DUMPSTK }> }> }END>c drop
B{b5ee9c7241010201008f0001fc8e7b20c700f240ed44d020d31f01f823bef282d303d3035321a0c209f24d04d72c200000000e317103c00013b0bb8e3103d0d71d2a5203c705f241028e1401d32301a4c8cb2301d71d03cf1601cf16c9ed54e101d70b27a4c8cb2701cf16c9ed54e06c229dd32301a4c8cb2301cf16c9ed54e1d70b27a4c8cb27c9ed54e1010018ed44d08020d721d303d70b03bf51fed9} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}

asm inline fun asm_fun_call_1(){

1000 constant //a
//a drop main PROC:<{ DUMPSTK }> %proposalState PROC:<{ DUMPSTK }>  __tact_selector_hack PROC:<{ DUMPSTK }> %aaa PROC:<{ DUMPSTK }> }> }END>c drop
    <{
        <{
            DUP
            SEMPTY
            <{ }> PUSHCONT IFJMP
            c4 PUSHCTR CTOS // stores data slice on top
            s0 PUSH         // s0 = data slice, s1 = data slice
            NOW             // data data now
            s0 s2 XCHG
            96 LDU
            s0 s1 XCHG
            64 RSHIFT#
            s1 s3 XCHG
            LEQ
            2 THROWIFNOT
            s0 s3 XCHG
            CTOS
            43 PLDSLICE
            s0 s3 PUXC
            SDEQ
            1 THROWIF
            s0 s1 XCHG
            x{00000001C_} SDBEGINSQ
            s1 POP
            <{
                s0 s1 XCHG
                64 LDU
                s0 s1 XCHG
                INC
                NEWC
                64 STU
                s0 s1 XCHG
                32 PLDSLICE
                STSLICER
                s0 s1 XCHG
                STSLICER
                ENDC
                c4 POPCTR
            }> PUSHCONT IFNOTJMP
            s0 s1 XCHG
            96 PLDU
            INC
            NEWC
            96 STU
            s0 s1 XCHG
            STSLICER
            ENDC
            c4 POPCTR
        }> PUSHCONT IFNOTJMP
        c4 PUSHCTR
        CTOS
        32 PUSHINT
        SDSKIPFIRST
        32 LDU
        32 PLDU
    }>c
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}