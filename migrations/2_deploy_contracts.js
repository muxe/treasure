var TreasureContract = artifacts.require("./TreasureContract.sol");
module.exports = function(deployer, helper, accounts) {
  return deployer.deploy(TreasureContract)
}
