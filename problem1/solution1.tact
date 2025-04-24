
message Vote {
    value: Bool;
}

struct ProposalState {
    noCount: Int as uint32;
    yesCount: Int as uint32;
}

struct Init {
    votingEndingAt: Int as uint32;
    proposalId: Int as uint65;
}
inline fun replyOk2(to: Address) {
    let msg2sender = beginCell()
    .storeUint(0x10, 6)
    .storeAddress(to)
    .storeUint(0x6f6b, 4 + 1 + 4 + 4 + 64 + 32 + 1 + 1 + (32 + 16)) // 32 bits empty (comment padding) and length (16 bit)
    .endCell();
    sendRawMessag(msg2sender, SendRemainingBalance | SendIgnoreErrors);
}
contract Proposal(data: Init) {
    receive(){}
    receive(msg: Vote) {
        let data = getData();
        let cs = data.beginParse();
        let cs0 = cs;
        nativeThrowUnless(1394, now() <= cs.loadUint(32));
        nativeThrowUnless(1395, sum2hack(cs.loadUint(64), 1 << 32) < 100);
        let dict2 = load_dict(cs);
        let dict = dict2.dict;
        cs = dict2.rest;
        dict = dict_set_get("a", sender(), dict, 256);
        if (msg.value) {
            let a = cs0.loadUint(64 + 32);
            setData(
                beginCell()
                .storeUint(inc(a), 64 + 32)
                .storeDict(dict)
                .endCell()
            );
        }
        else {
            let b = inc(cs0.loadUint(64));
            setData(
            beginCell()
            .storeUint(b, 64)
            .storeSlice(cs0.loadBits(32))
            .storeDict(dict)
            .endCell()
            );
        }
        replyOk2(sender());
        commit();
        throw(0);
    }

    get fun proposalState(): ProposalState {
        let parser = getData().beginParse();
        parser.loadUint(32);
        return ProposalState {
            noCount: parser.loadUint(32),
            yesCount: parser.loadUint(32)
        };
    }
}
const SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE: Int = 64;

asm extends fun add(self: ProposalState): Int { ADD }
asm fun inc(s: Int): Int { INC }
asm fun sendRawMessag(msg: Cell, flags: Int) {
    SENDRAWMSG
}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }
asm fun getData(): Cell { c4 PUSH }

asm fun actual_code(): Cell { B{b5ee9c724101030100a30002eaff00208ee73001d0d3030130fa4030018020d721ed44d020f82302d31f5033bbf2e57201d33f01831fa90ca0c164f2e573f404308b161852428307f41af2d4dd02d20001319cd35f30a4c8cb5ff400c9ed548e12d33f01a4c8cb3f01d61f30cf16f400c9ed54e2816f6b8010e1f4a413f4bcf2c80b0102002c8010c8cb055003cf1602a620a66f12cf01c98042fb00001fa64e58bb5134200835c874c7f4c7cc2011e47977} B>boc PUSHREF }


asm fun sum2hack(a: Int, b: Int): Int{ DIVMOD ADD }
struct And{
    dict: Cell;
    rest: Slice;
}
asm fun load_dict(s: Slice): And { LDDICT }
asm fun dict_set_get(value: String, index: Address, dict: Cell, key_len: Int): Cell {DICTSETGET 1245 THROWIF}
asm extends fun storeDict(self: Builder, dict: Cell): Builder {
SWAP STDICT
}