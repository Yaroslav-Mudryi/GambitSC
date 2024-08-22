const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

module.exports = {
  contracts_build_directory: './build',
  contracts_directory: './contracts',

  networks: {
    arbitrum: {
      network_id: 42161,
      chain_id: 42161,
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, "https://rpc.ankr.com/arbitrum", 0, 1);
      }
    },
  },

  mocha: {
    timeout: 100000
  },
  compilers: {
    solc: {
      version: "0.8.19",
      settings:  {
        optimizer: {
          enabled: true,
          runs: 800
        }
      }
    },
  },
  db: {
    enabled: false
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    arbiscan: process.env.ARBISCAN_API
  }
}
