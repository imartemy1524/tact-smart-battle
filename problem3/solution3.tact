message(1) Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint4;
    yesCount: Int as uint4;
}

struct G {
    a: Bool;
    b: Bool;
}

struct Init {
    proposalId: Int as uint100;
    votingEndingAt: Int as uint256;

    // wee need one ref to be presented
//
//    cell3: Cell?;
//    cell4: Cell?;
//    cell5: Cell?;
//    cell4: Cell?;
//    cell5: Cell?;

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
B{b5ee9c7241021c0100017500011e8e8420c700dce1ed44d0d303d70b03010468ed44d0d72c08048f1c308210680fc6a8f823bef282d72c200000000e8e8388ed54e088ed54e0d72c088c8e8388ed54e0d72c080c0203040500020100021000022104648f1e3001d0802bd721d72c0731f241d72c200000000e318e8388ed54e188ed54e06c21d72c090c8e843088ed54e0d72c0914060708090003112000020200022204408e8388ed54e0d72c08148e843088ed54e0d72c081c8e843088ed54e0d72c08240a0b0c0d00023200020300020404428e843088ed54e0d72c082c8e843088ed54e0d72c08348e843088ed54e0d72c083c0e0f101100020500020600020704428e843088ed54e0d72c08448e843088ed54e0d72c08408e843088ed54e0d72c09941213141500020800020900020a04428e843088ed54e0d72c0a148e843088ed54e0d72c0a1c8e843088ed54e0d72c0a9c16171819000242000243000253022a8e843088ed54e0d72c0b1c318e8388ed54e0f2c07b1a1b00026300026495684588} B>boc drop
<{
    <{
    DUP SEMPTY IFRET
    c4 PUSH CDEPTH
    IFNOTJMP:<{
        now 3600 24 * + 8 + PUSHINT NOW GEQ
        2 THROWIFNOT
        x{00000001C_} SDBEGINSQ
        <{
        <b x{01} s, <b b> ref, b> PUSHREF POPROOT
        }> PUSHCONT
        IFJMP
        <b x{10} s, <b b> ref, b> PUSHREF POPROOT
    }>

    c4 PUSH CTOS
    x{11} SDBEGINSQ
    IFJMP:<{
        <b x{21} s, <b b> ref, b> PUSHREF POPROOT
    }>

    x{01} SDBEGINSQ IFJMP:<{
        DROP
        SWAP
        CTOS
        43 PUSHINT
        SDSKIPFIRST
        x{E_} SDBEGINSQ
        NIP
        1 THROWIF
        x{00000001C_} SDBEGINSQ
       // NIP
        IFNOTJMP:<{
            <b x{112_} s, <b b> ref, b> PUSHREF POPROOT
        }>

        <b x{02} s, <b b> ref, b> PUSHREF POPROOT
    }>
    2 1 BLKDROP2
    x{21} SDBEGINSQ
    <{
        // DROP
        <b x{22} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{22} SDBEGINSQ
    <{
        <b x{32} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{02} SDBEGINSQ
    <{
        // DROP
        <b x{03} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{03} SDBEGINSQ
    <{
        // DROP
        <b x{04} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{04} SDBEGINSQ
    <{
        // DROP
        <b x{05} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{05} SDBEGINSQ
    <{
        // DROP
        <b x{06} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{06} SDBEGINSQ
    <{
        // DROP
        <b x{07} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{07} SDBEGINSQ
    <{
        // DROP
        <b x{08} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{08} SDBEGINSQ
    <{
        // DROP
        <b x{09} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT
    IFJMP
    x{0} SDBEGINSQ
    <{
       // DROP
        <b x{0A} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    x{32} SDBEGINSQ
    <{
       // DROP
        <b x{42} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    x{42} SDBEGINSQ
    <{
       // DROP
        <b x{43} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    x{43} SDBEGINSQ
    <{
       // DROP
        <b x{53} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    x{53} SDBEGINSQ
    <{
       // DROP
        <b x{63} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    x{63} SDBEGINSQ
    NIP
    <{
        <b x{64} s, <b b> ref, b> PUSHREF POPROOT
    }> PUSHCONT IFJMP
    123 THROW
    }> PUSHCONT IFNOTJMP
    PUSHROOT
    CTOS
    4 LDU
    4 PLDU
}>c
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}


