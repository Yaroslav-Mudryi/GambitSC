const PaalBet = artifacts.require("PaalBet");

module.exports = function (deployer) {
  deployer.deploy(
    PaalBet,
    "0xae56177e405929c95E5d4b04C0C87E428cB6432B",
    "0x2Bb7D689780e7a34dD365359bD7333ab24903268",
    "0xc96e0d2a43d27d9ae1e0afc6a21eba691d94a62b"
  );
};

// address _SportsAMM
// address _ParlayMarketsAMM
// address _treasury