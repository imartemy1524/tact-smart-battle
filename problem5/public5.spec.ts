import '@ton/test-utils';
import { Blockchain, printTransactionFees } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Proposal } from '../output/solution5_Proposal';

it('solution5', async () => {
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
    const {transactions} = await proposal.send(
        deployer.getSender(),
        {
            value: toNano('0.01'),
        },
        null, // empty message, handled by `receive()` without parameters
    );
    printTransactionFees(transactions)

    // vote
    const voter = await blockchain.treasury('voter');
    const {transactions: transactions2} = await proposal.send(
        voter.getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: true,
        },
    );
    printTransactionFees(transactions2);

    // the vote was counted
    expect(await proposal.getProposalState()).toMatchObject({ yesCount: 1n, noCount: 0n });
    {
        const { transactions } = await proposal.send(
            voter.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: true,
            },
        );
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: 1n, noCount: 0n });
    }
    {
        const { transactions } = await proposal.send(
            voter.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: false,
            },
        );
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: 1n, noCount: 0n });
        printTransactionFees(transactions);
    }
    {
        const { transactions } = await proposal.send(
            (await blockchain.treasury("tete")).getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: false,
            },
        );
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: 1n, noCount: 1n });
    }
});