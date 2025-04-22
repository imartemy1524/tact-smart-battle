message Vote { value: Bool;}
struct ProposalState { yesCount: Int as uint32;noCount: Int as uint32;}
struct Init { proposalId: Int as uint32; votingEndingAt: Int as uint32;}
message(0x1234) OnError{ owner: Address; vote: Bool;}
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
    receive(){
        throw(123);
    }

    receive(msg: Vote) {
        let parser = getData().beginParse();
        let parser0 = getData().beginParse();
        parser.skipBits(1);
        nativeThrowIf(123, parser.loadUint(32) < now());
        let ___q = (sender()).asSlice().hash();
        let hash = ___q; //___q.hash;
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
            .storeUint(parser0.loadUint(32) + (!changed && msg.value ? 1 : 0), 32)  // store uint32 + uint32 + dict(none)
            .storeUint(parser0.loadUint(32) + (msg.value || changed ? 0 : 1), 32)  // store uint32 + uint32 + dict(none)
            .storeRef(item)
            .endCell()
        );
        commit();
        throw(0);
    }

    get fun proposalState(): ProposalState {
        let cs = getData().beginParse();
        cs.skipBits(33);
        let a = cs.loadUint(32);
        let b = cs.loadUint(32);
        return ProposalState{yesCount: a, noCount: b};
    }

}
contract Boba(r: Address){
    receive("ok"){
        // pass
    }
}


asm fun parse_std_addr(s: Address): Addr {
    REWRITESTDADDR
}
struct Addr{
    chain: Int;
    hash: Int;
}
struct DivModRes{
    res: Int;
    mod: Int;
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
