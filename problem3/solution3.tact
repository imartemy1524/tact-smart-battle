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
B{b5ee9c7241020e010001260004f88ff9eda2edfb20c700f240ed44d020d303d3035321a0c209f24d22c00022c000b09920d70b1ff823bef2828e8522c000e300e204d72c200000000e317103c00013b0bb8e3103d0d71d2a5203c705f241028e1401d30301a4c8cb0301d71d03cf1601cf16c9ed54e101d70b07a4c8cb0701cf16c9ed54e06c22e303e1010b0c0d045421c0028e875f0688ed54db31e021c0038e875f0688ed54db31e021c0048e875f0688ed54db31e021c00502030405000203000204000205044e8e875f0688ed54db31e021c0068e875f0688ed54db31e021c0078e875f0688ed54db31e021c0080607080900020600020700020801148e875f0688ed54db31e00a000209001ad30301a4c8cb0301cf16c9ed540014d70b07a4c8cb07c9ed540010ed44d0d303d70b03a75e8687} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
