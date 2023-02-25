const SimpleStorage = artifacts.require("temp_sbt");

module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "temp_sbt", "tsbt");
};
