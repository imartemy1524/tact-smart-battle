message(1) Vote { value: Bool;}
struct ProposalState { noCount: Int as uint32;yesCount: Int as uint32;}
struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint64;
}
message(0x1234) OnError{ owner: Address; vote: Bool;}

contract Proposal(data: Init) {
    receive(){ }

    receive(msg: Vote) { throw(123);}

    get(-14) fun proposalState(): ProposalState { return ProposalState{yesCount: 0, noCount: 0};}
    get fun aaa(){
        asm_fun_call();
    }
}

asm inline fun asm_fun_call() {
1000 constant //a
//a drop main PROC:<{ DUMPSTK }> %proposalState PROC:<{ DUMPSTK }>  __tact_selector_hack PROC:<{ DUMPSTK }> %aaa PROC:<{ DUMPSTK }> }> }END>c drop
B{b5ee9c724101020100970001448e9320c700925f03e002821005f5e100be915be30de1ed44d08020d721d31fd70b1f0100e0ed44d020f82302d35f01ab3f13bbf28202d074d721fa403020c8cf850801cf168be00000000000000000000000000010cf16c98042fb0021c7005121c705b312b1f28102d72c200000000e319dd70b5fa4c8cb5f01cf16c9ed548e13d33f01a4c8cb3f01d71d1fcf1601cf16c9ed54e20667d916} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}