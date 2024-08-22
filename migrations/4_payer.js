const GRMinter = artifacts.require("GRMinter");

module.exports = function (deployer) {
  deployer.deploy(
    GRMinter,
    "0x34053Ca69E501dA8f8200F21ED9467eAAEf0f9d2",
    "25000000000000000000"
  );
};

