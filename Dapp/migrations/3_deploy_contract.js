let CrowdFunding = artifacts.require("./CrowdFunding.sol")


module.exports = async function(deployer) {
    deployer.deploy(
        CrowdFunding,
        "First project",
        1,
        10,
        "0xC7D8F2af9BA6b3635e3c457341Dc92Ed800555F3"
        );
}