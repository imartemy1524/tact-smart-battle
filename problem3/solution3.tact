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
B{b5ee9c72410217010001d60003e08fe5eda2edfb20c700f240ed44d020d303d3035321a0c209f24d22c00022c000b09920d70b1ff823bef2828f0c22c0008e8522c200e300e30de204d72c200000000e317103c00013b0bbe3026c229dd30301a4c8cb0301cf16c9ed54e1d70b07a4c8cb07c9ed54e1ed44d0d303d70b03010c16045c21c00123c001b08e875f0688ed54db31e021c0018e875f0688ed54db31e022c0028e875f0688ed54db31e022c0030203040500022100022200023204668e875f0688ed54db31e021c00223c004b08e875f0688ed54db31e022c00422c003b08e875f0688ed54db31e022c00522c003b00607080900024200024300025302368e875f0688ed54db31e022c00622c003b08e875f0688ed54db31e00a0b000263000264045421c0028e875f0688ed54db31e021c0038e875f0688ed54db31e021c0048e875f0688ed54db31e021c0050d0e0f10000203000204000205044e8e875f0688ed54db31e021c0068e875f0688ed54db31e021c0078e875f0688ed54db31e021c0081112131400020600020700020801148e875f0688ed54db31e015000209007803d0802bd721d71d015203c70522d70b01c003b0f241028e1401d30301a4c8cb0301d71d03cf1601cf16c9ed54e101d70b07a4c8cb0701cf16c9ed54b8eae73f} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
