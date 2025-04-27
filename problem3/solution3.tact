message(1) Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint4;
    yesCount: Int as uint4;
}

struct Init {
    proposalId: Int as uint8;
    votingEndingAt: Int as uint32;
    // proposal id is always 0 BTW
}
struct G {
    a: Bool;
    b: Bool;
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
B{b5ee9c7241021d010001730001208e8520c700f240e1ed44d0d303d70b03010460ed44d0d72c08048f18d70b1ff823bef282d72c200000000e8e8388ed54e088ed54e0d72c088c8e8388ed54e0d72c080c0203040500020100021000022104648f1e3001d0802bd721d72c0731f241d72c200000000e318e8388ed54e188ed54e06c21d72c090c8e843088ed54e0d72c0914060708090003112000020200022204368e8388ed54e0d72c0840e302d72c09948e843088ed54e0d72c0a140a0b1617000232044ad72c09408e843088ed54e0d72c09c08e843088ed54e0d72c0a408e843088ed54e0d72c0ac00c0d0e0f00020300020400020504448e843088ed54e0d72c0b408e843088ed54e0d72c0bc08e843088ed54e0d72c0c40311011121300020600020700020802128e8388ed54e088ed54141500020900020a00024204448e843088ed54e0d72c0a1c8e843088ed54e0d72c0a9c8e843088ed54e0d72c0b1c3118191a1b00024300025300026301128e8388ed54e0f2c07b1c000264f0f8e9a2} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
