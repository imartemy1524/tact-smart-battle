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
            proposalId: 1234567n,
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


    for (let i = 0; i < 50; i++) {
        // vote
        const voter = await blockchain.treasury('voter' + i);
        const { transactions } = await proposal.send(
            voter.getSender(),
            { value: toNano('0.1') },
            {
                $$type: 'Vote',
                value: true,
            },
        );
        console.log(fromNano(transactions[1].totalFees.coins));
        expect(transactions).toHaveTransaction({
            to: voter.getSender().address
        })
        if(i != 49)
            await proposal.send(
                (await blockchain.treasury('avoter' + i)).getSender(),
                { value: toNano('0.1') },
                {
                    $$type: 'Vote',
                    value: false,
                },
            );
    }
    const voter = await blockchain.treasury('voter0');

    await proposal.send(
        voter.getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: true,
        },
    );
    //     console.log(fromNano(tr2[1].totalFees.coins));
    const state = await proposal.getProposalState();
    // the vote was counted
    expect(state).toMatchObject({ yesCount: 50n, noCount: 49n });
    await proposal.send(
        (await blockchain.treasury("111")).getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: true,
        },
    );
    await proposal.send(
        (await blockchain.treasury("222")).getSender(),
        { value: toNano('0.1') },
        {
            $$type: 'Vote',
            value: true,
        },
    );
    expect(await proposal.getProposalState()).toMatchObject({ yesCount: 51n, noCount: 49n });

});

