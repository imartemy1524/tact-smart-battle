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
B{b5ee9c7241021d010001bc0001168e80e1ed44d0d303d70b0301046620c700f240ed44d0d72c08048f18d70b1ff823bef282d72c200000000e8e8388ed54e088ed54e0d72c0840e3026c12d72c088c02030412000301e0000210046ad30321c0018f1d3102d0802bd72158c709f241d72c200000000e318e8388ed54e188ed54e0135f0320c0028e843088ed54e020c0030506070800031120000202000203043c8e843088ed54e020c0048e843088ed54e020c0058e843088ed54e020c006090a0b0c000204000205000206043a8e843088ed54e020c0078e843088ed54e020c0088e843088ed54e0c0090d0e0f10000207000208000209010c8e8388ed54e01100020a04588e845b88ed54e020d303d303305ca0c209f24d20c0018e855f0488ed54e021c0028e855f0488ed54e021c00313141516000221000222000232045a8e855f0488ed54e020c00222c004b08e855f0488ed54e021c00421c003b08e855f0488ed54e021c00521c003b01718191a00024200024300025302868e855f0488ed54e021c00621c003b08e855f0488ed54e003d72c200000000e3103c00001c001b0f241019dd30301a4c8cb0301cf16c9ed54e1d70b07a4c8cb07c9ed541b1c000263000264b3301c03} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}
