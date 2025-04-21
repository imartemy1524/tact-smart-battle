import '@ton/test-utils';
import { Blockchain, printTransactionFees } from '@ton/sandbox';
import { fromNano, toNano } from '@ton/core';
import { Proposal } from '../output/solution1_Proposal';

it('solution1', async () => {
    const blockchain = await Blockchain.create();

    // create contract from init()
    const proposal = blockchain.openContract(
        await Proposal.fromInit({
            $$type: 'Init',
            proposalId: 0n,
            votingEndingAt: BigInt(Math.floor(Date.now() / 1000)) + 24n * 60n * 60n,
        }),
    );

    // deploy contract
    const deployer = await blockchain.treasury('deployer');
    await proposal.send(
        deployer.getSender(),
        {
            value: toNano('0.01'),
        },
        null, // empty message, handled by `receive()` without parameters
    );

    // vote
    const voter = await blockchain.treasury('voter');
    const {transactions} = await proposal.send(
        voter.getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: true,
        },
    );
    const {transactions: tr2} = await proposal.send(
        (await blockchain.treasury('voter2')).getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: false,
        },
    );
    console.log(fromNano(tr2[1].totalFees.coins));
    const state = await proposal.getProposalState();
    // the vote was counted
    expect(state).toMatchObject({ yesCount: 1n, noCount: 1n });
});