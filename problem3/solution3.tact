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
B{b5ee9c724101030100920002fa8efa20c700f240ed44d020d303d30322c00022c000b09920d70b1ff823bef282de04d72c200000000e3101c10202c00012b08e3103d0d71d2a5203c705f241028e1401d30301a4c8cb0301d71d03cf1601cf16c9ed54e101d70b07a4c8cb0701cf16c9ed54e06c229dd30301a4c8cb0301cf16c9ed54e1d70b07a4c8e10102000acb07c9ed540010ed44d0d303d70b03528420d5} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
