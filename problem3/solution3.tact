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
    proposalId: Int as uint8;
    votingEndingAt: Int as uint32;
    // wee need one ref to be presented

//    cell1: Cell?;
//    cell2: Cell?;
//    cell3: Cell?;
//    cell4: Cell?;
//    cell4: Cell?;

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
B{b5ee9c7241021c0100017500011e8e8420c700dce1ed44d0d303d70b03010468ed44d0d72c08048f1c308210680f9c0ff823bef282d72c200000000e8e8388ed54e088ed54e0d72c088c8e8388ed54e0d72c080c0203040500020100021000022104648f1e3001d0802bd721d72c0731f241d72c200000000e318e8388ed54e188ed54e06c21d72c090c8e843088ed54e0d72c0914060708090003112000020200022204408e8388ed54e0d72c08148e843088ed54e0d72c081c8e843088ed54e0d72c08240a0b0c0d00023200020300020404428e843088ed54e0d72c082c8e843088ed54e0d72c08348e843088ed54e0d72c083c0e0f101100020500020600020704428e843088ed54e0d72c08448e843088ed54e0d72c08408e843088ed54e0d72c09941213141500020800020900020a04428e843088ed54e0d72c0a148e843088ed54e0d72c0a1c8e843088ed54e0d72c0a9c16171819000242000243000253022a8e843088ed54e0d72c0b1c318e8388ed54e0f2c07b1a1b0002630002649d7b61fe} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}

