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
B{b5ee9c724102190100020d0001168e80e1ed44d0d303d70b0301048ceda2edfb20c700f240ed44d0d72c08048f1b6c12d70b1ff823bef282d72c200000000e8e8388ed54e13088ed54e020d303d30322c000e3005321a0c209f24d21c00123c001b00203040e000210000301e004ee21c0018e4705d0802bd721d71d015206c70525d70b01c003b0f24103d72c200000000e318e173031d30301a4c8cb0301d71d03cf1601cf16c9ed54db31e13132a401c8cb03cb03c9ed54db31e021c0028e875f0688ed54db31e021c0038e875f0688ed54db31e021c0048e875f0688ed54db31e021c00505060708000203000204000205044e8e875f0688ed54db31e021c0068e875f0688ed54db31e021c0078e875f0688ed54db31e021c008090a0b0c00020600020700020801148e875f0688ed54db31e00d00020904428e855f0688ed54e021c0018e855f0688ed54e022c0028e855f0688ed54e022c003180f1011000222000232045a8e855f0688ed54e021c00223c004b08e855f0688ed54e022c00422c003b08e855f0688ed54e022c00522c003b01213141500024200024300025303d28e855f0688ed54e022c00622c003b08e855f0688ed54e004d72c200000000e3121c00023c001b0f24101c00102c00112b08e9a5b01d0802bd721d71d015202c70501d70b01c003b0f24188ed54e06c229dd30301a4c8cb0301cf16c9ed54e1d70b07a4c8cb07c9ed54161718000263000264000221c8264e41} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
