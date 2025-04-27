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
B{b5ee9c7241021d010001870001208e8520c700f240e1ed44d0d303d70b03010460ed44d0fe00d72c08048f18d70b1ff823bef282d72c200000000e8e8388ed54e088ed54e0d72c0840e3026c21d72c091402030412000301e00002100468d72c08c08f1c02d0802bd72158c709f241d72c200000000e318e8388ed54e188ed54e06c21d72c09408e843088ed54e0d72c09c0050607080003112000020200020304428e843088ed54e0d72c0a408e843088ed54e0d72c0ac08e843088ed54e0d72c0b40090a0b0c000204000205000206043a8e843088ed54e0d72c0bc08e843088ed54e0d72c0c40318e8388ed54e00d0e0f10000207000208000209010688ed541100020a044a8e843088ed54e0d72c088c8e843088ed54e0d72c090c8e843088ed54e0d303d3033021c0031314151600023200022100022204548e845b88ed54e020c00222c004b08e845b88ed54e021c00421c003b08e845b88ed54e021c00521c003b01718191a000242000243000253022e8e845b88ed54e001c00601c003b08e8388ed54e0f2c07b1b1c0002630002646f43c7f3} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
