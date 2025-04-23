import '@ton/test-utils';
import { Blockchain, printTransactionFees } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Proposal } from '../output/solution3_Proposal';

it('3', async () => {
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
    const { transactions } = await proposal.send(
        deployer.getSender(),
        {
            value: toNano('0.01'),
        },
        null, // empty message, handled by `receive()` without parameters
    );
    printTransactionFees(transactions);
    const count = 200n;
    for (let i = 0; i < Number(count); i++) {
        const sender = await blockchain.treasury(`voter${i}`);
        const { transactions: transactions2 } = await proposal.send(
            sender.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: true,
            },
        );
        printTransactionFees(transactions2);

        expect(await proposal.getProposalState()).toMatchObject({ yesCount: BigInt(i + 1), noCount: 0n });
    }
    const voter = await blockchain.treasury('voter10');
    {
        const { transactions: transactions1 } = await proposal.send(
            voter.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: true,
            },
        );
        printTransactionFees(transactions1)
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: count, noCount: 0n });

        const { transactions } = await proposal.send(
            voter.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: false,
            },
        );
        printTransactionFees(transactions);
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: count, noCount: 0n });
    }
    {
        const { transactions } = await proposal.send(
            (await blockchain.treasury('tete')).getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: false,
            },
        );
        expect(await proposal.getProposalState()).toMatchObject({ yesCount: count, noCount: 1n });
    }
});
