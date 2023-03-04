const SimpleStorage = artifacts.require("ARS_token");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "Alice Ring Soul", "Ring_Soul");
};
