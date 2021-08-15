let CrowdFunding = artifacts.require("./CrowdFunding.sol")


module.exports = async function(deployer) {
    deployer.deploy(
        CrowdFunding,
        "First project",
        1,
        10,
        ""
        );
}