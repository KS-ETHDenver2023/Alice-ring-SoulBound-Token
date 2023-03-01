const SimpleStorage = artifacts.require("PoS_token");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "Alice's Ring Token", "ring_sbt");
};
