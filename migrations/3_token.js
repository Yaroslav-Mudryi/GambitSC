const GambitReferralDev = artifacts.require("GambitReferralDev");

module.exports = function (deployer) {
  deployer.deploy(
    GambitReferralDev,
    "0xEf5D662a4d6bD146d82490024E7cA040f29424B2"
  );
};

