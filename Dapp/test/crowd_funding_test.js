let CrowdFunding = artifacts.require('./TestCrowdFunding')
const BigNumber = require('BigNumber.js')


contract('CrowdFunding', function(accounts) {
    let contract;
    let contractOwner = accounts[0];
    let beneficiary = accounts[1];

    const ONE_ETH = new BigNumber(1000000000000000000);
    const ERROR_MSG = 'Returned error: VM Exception while processing transaction: revert';
    const ONGOING_STATE = 0;
    const FAILED_STATE = 1;
    const SUCCEEDED_STATE = 2;
    const PAID_OUT_STATE = 3;

    beforeEach(async function() {
        contract = await CrowdFunding.new('Funding', 1, 5, beneficiary, {from: contractOwner, gas: 2000000})
    })

    it('contract is initialized', async function() {
        let contractName = await contract.name.call()
        expect(contractName).to.equal('Funding');
    })

    it('funds are contributed', async function() {
        await contract.contribute({value: ONE_ETH, from: contractOwner});

        let contributed = await contract.amounts.call(contractOwner);
        expect(ONE_ETH.isEqualTo(contributed)).to.equal(true);
    })

    it('Deadline passed. Cannot contribute', async function() {
        await contract.contribute({value: ONE_ETH, from: contractOwner});

        let contributed = await contract.amounts.call(contractOwner);
        expect(ONE_ETH.isEqualTo(contributed)).to.equal(true);
    })

    it('Paidout collected money', async function() {
        await contract.contribute({value: ONE_ETH, from: contractOwner});
        await contract.setCurrentTime(601);
        await contract.finishCrowdFunding();

        let initAmount = await web3.eth.getBalance(beneficiary);
        await contract.collect({from: contractOwner});

        let newBalance = await web3.eth.getBalance(beneficiary);
        let difference = newBalance - initAmount;
        expect(ONE_ETH.isEqualTo(difference)).to.equal(true);

        let fundingState = await contract.state.call()
        expect(fundingState.valueOf().toNumber()).to.equal(PAID_OUT_STATE);
    })

    it('withdraw funds from the contract', async function() {
        await contract.contribute({value: ONE_ETH - 100, from: contractOwner});
        await contract.setCurrentTime(601);
        await contract.finishCrowdFunding();

        await contract.withdraw({from: contractOwner});
        let amount = await contract.amounts.call(contractOwner);
        expect(amount.toNumber()).to.equal(0);
    });
});