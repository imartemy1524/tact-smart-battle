message Vote { value: Bool;}
struct ProposalState { yesCount: Int as uint32;noCount: Int as uint32;}
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32;}
message(0x1234) OnError{ owner: Address; vote: Bool;}
struct Addr{
    chain: Int;
    hash: Int;
}
struct DivModRes{
    res: Int;
    mod: Int;
}
const none: Cell = cell("te6cckEBAQEAggAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABCdJzEQ==");
inline fun buildFilter(depth: Int): Cell{
    if(depth == 0) {
        return none;
    }
    let cell = beginCell();
    let toInsert = buildFilter(depth - 1);
    cell = cell.storeRef(toInsert)
    .storeRef(toInsert)
    .storeRef(toInsert)
    .storeRef(toInsert);
    return cell.endCell();
}
mutates extends inline fun setValueAt(self: Cell, index: Int, depth: Int): Bool{
    if(depth == 0){
        let orig = self;
        let orig2 = orig.beginParse();
        let a = index % 1023;
        let stays = orig2.loadBits(a);
        let valid = orig2.loadBool();
        if(valid){
            self = orig;
        }
        else {
            self = beginCell().storeSlice(stays).storeBool(true).storeSlice(orig2).endCell();
        }
        return valid;
    }
    let rewIndexA = divmod(index, 4);
    let ans = beginCell();
    let orig = self.beginParse();
    repeat (rewIndexA.mod) {
        let item = orig.loadRef();
        ans = ans.storeRef(item);
    }
    let item = orig.loadRef();
    let modified = item.setValueAt(rewIndexA.res, depth - 1);
    ans = ans.storeRef(item)
    .storeSlice(orig);
    self = ans.endCell();
    return modified;
}
contract Proposal {

    init(data: Init) {
        let ref = buildFilter(3);
        setData(
        beginCell()
        .storeBit(true)
        .storeUint(data.votingEndingAt, 32)
        .storeUint(0, 64)
        .storeRef(ref)
        .endCell()
        );
        commit();
        throw(0);
    }
    receive(){}

    receive(msg: Vote) {
        if(context().value < ton("0.1")){
            throw(937);
        }
        let parser = getData().beginParse();
        let parser0 = getData().beginParse();
        parser.skipBits(1);
        nativeThrowIf(123, parser.loadUint(32) < now());
        //        nativeThrowIf(124, sum2(parser.loadUint(64), 1<<32) >= 100);
        let ___q = parse_std_addr(sender());
        let hash = ___q.hash;
        let item = parser.loadRef();
        let changed = true;
        repeat(7){
            let g = divmod(hash, 1 << 16);
            hash = g.res;
            let bob = item.setValueAt(g.mod, 3);
            changed = changed && bob;
        }
        // all true - already exists
        require(!changed, "Already exists");
        setData(
            beginCell()
                .storeSlice(parser0.loadBits(33))
                .storeUint(parser0.loadUint(32) + (msg.value ? 1 : 0), 32)  // store uint32 + uint32 + dict(none)
                .storeUint(parser0.loadUint(32) + (msg.value ? 0 : 1), 32)  // store uint32 + uint32 + dict(none)
                .storeRef(item)
                .endCell()
        );
        self.reply("ok".asComment());
        commit();
        throw(0);
    }

    get fun proposalState(): ProposalState {
        let p = getData().beginParse();
        p.skipBits(33);
        return ProposalState{
        yesCount: p.loadUint(32),
        noCount: p.loadUint(32)
        };
    }

}
asm extends fun refAt(self: Slice, index: Int): Cell{
    PLDREFVAR
}
asm fun sum2(a: Int, mod: Int): Int {
    DIVMOD ADD
}
asm fun divmod(a: Int, mod: Int): DivModRes {
    DIVMOD
}
asm fun setCode(code: Cell) { SETCODE }
asm fun setData(code: Cell) { c4 POP }
asm fun getData(): Cell { c4 PUSH }
asm fun parse_std_addr(s: Address): Addr {
    REWRITESTDADDR
}
