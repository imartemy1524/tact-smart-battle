struct ProposalInit {
    master: Address;
    proposalId: Int as uint32;
}

message DeployNewProposal {
    votingEndingAt: Int as uint32;
}
contract ProposalMaster {
    id: Int as uint32 = 0;
    // deploy
    receive() { }

    receive(msg: DeployNewProposal) {
        require(msg.votingEndingAt >= now(), "Proposal expired");
        let state = initOf Proposal(ProposalInit{master: myAddress(), proposalId: self.id});
        self.id += 1;
        let addr = contractAddress(state);
        send(SendParameters{
            to: addr,
            mode: SendRemainingValue,
            body: DeployNewProposal{
                votingEndingAt: msg.votingEndingAt
            }.toCell(),
            value: 0,
            code: state.code,
            data: state.data,
        });
    }
    get fun nextProposalId(): Int {
        return self.id;
    }
}

// ==============================================================================

message Vote {
    value: Bool;
}

struct ProposalState {
    yesCount: Int as uint32;
    noCount: Int as uint32;
    master: Address;
    proposalId: Int as uint32;
    votingEndingAt: Int as uint32;
}

contract Proposal {
    votingEndingAt: Int as uint32 = 0;
    yesCount: Int as uint32 = 0;
    noCount: Int as uint32 = 0;
    master: Address;
    proposalId: Int as uint32;
    dictWithData: Bool = false;
    init(data: ProposalInit){
        self.master = data.master;
        self.proposalId = data.proposalId;
    }

    receive(m: Slice){
        nativeThrowUnless(2025, sender() == self.master);
        setData(
            beginCell()
            .storeSlice(m)
            .storeUint(0, 64)
            .storeAddress(self.master)
            .storeUint(self.proposalId, 32)
            .storeBit(0)
            .endCell()
        );
        setCode(actual_code());
        commit();
        throw(0);
    }
    receive(msg: Vote) {
        // TODO: be in code
    }

    get fun proposalState(): ProposalState {
        let address: Address? = null;
        return ProposalState{
            yesCount: 0,
            noCount: 0,
            master: address!!,
            proposalId: 0,
            votingEndingAt: 0
        };
    }
}

asm fun sendRawMessag(msg: Cell, flags: Int) {SENDRAWMSG}
asm fun setCode(code: Cell) {SETCODE}
asm fun setData(code: Cell) { c4 POP }

asm fun actual_code(): Cell { B{b5ee9c724102060100010f0003a2ff00208f433020c700915be001d0d30301db3c0371b08e1e33038020d721d200019202a59301a558e202d102c8cb1fcb1fcb1fc9ed54e004d72c20c9db1e6c965f05840ff2f0e30de1f4a413f4bcf2c80b05010401be03fa4030f82322bbf2e57203d20030209204a49402a44014e25802c8cb1fcb1fcb1fc9ed54010170c8f828cf1658cf16c98822c8cb01f400f400cb00c9768018c8cb0522f9007074c8cb02ca07cbffc9d0cf16cb6fcc0101ca00c98040fb00020114ff00f4a413f4bcf2c80b030062d3c7009130e0d0d3030171b09130e0fa4030ed44d0fa405112c705f2e3e7d70b01c000f2d4bcc801cf167001cb01c9ed54010fa64e58b6cf1b04a0050014ed44d0d31fd31fd31fd156448f28} B>boc PUSHREF }
