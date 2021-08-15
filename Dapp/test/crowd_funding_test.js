let CrowdFunding = artifacts.require('./TestCrowdFunding')
const BigNumber = require('BigNumber.js')


contract('CrowdFunding', function(accounts)) {
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
        contract = await CrowdFunding.new('Funding', 1, 5, beneficiary, {from: contractCreator, gas: 2000000})
    })

    it('contract is initialized', async function() {
        let contractName = await contract.name.call()
        expect(contractName).to.equal('Funding');
    })
}