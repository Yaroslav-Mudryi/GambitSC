const Gambitv2 = artifacts.require("Gambitv2");

module.exports = function (deployer) {
  deployer.deploy(
    Gambitv2,
    "0xFb4e4811C7A811E098A556bD79B64c20b479E431",
    "0x3b834149F21B9A6C2DDC9F6ce97F2FD1097F8EAB",
    "0xc96e0d2a43d27d9ae1e0afc6a21eba691d94a62b"
  );
};

// address _SportsAMMv2
// address _LiveTradingProcessor
// address _treasury