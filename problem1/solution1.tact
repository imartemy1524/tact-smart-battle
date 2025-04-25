
message Vote { value: Bool;}

struct ProposalState { noCount: Int as uint32; yesCount: Int as uint32;}

struct Init { votingEndingAt: Int as uint32; proposalId: Int as uint97; }

contract Proposal(data: Init) {
    receive(){ }
    receive(msg: Vote) { }

    get(-14) fun proposalState(): ProposalState {
        return ProposalState{
        yesCount: 0,
        noCount: 0
        };
    }
    get fun asm_fun_callt(){ asm_fun_call(); }

}


asm inline fun asm_fun_call() {
1000 constant //a
//a drop main PROC:<{ DUMPSTK }> %proposalState PROC:<{ DUMPSTK }>  __tact_selector_hack PROC:<{ DUMPSTK }> %asm_fun_callt PROC:<{ DUMPSTK }> }> }END>c drop
B{b5ee9c724101030100910002fa8efa20c700915be001d07481010bd72420708010c8cb0558cf16cb6ec98042fb00ed44d020f82302d31f5033bbf2e15901d33f01831fa90ca0c164f2e15af4058803d70bff43008307f46f810dcc016ef2f4028020d721d20001318e12d33f01a4c8cb3f01d71d1fcf16f400c9ed54e1d70b5fa4c8cb5ff400c9ed54e1010200000018ed44d08020d721d31fd31f302eb6e1af} B>boc
dup hashB B>X $>B "hex" B>file
2 boc+>B dup
"res" B>file
B>base64 $>B "boc" B>file
bye
}