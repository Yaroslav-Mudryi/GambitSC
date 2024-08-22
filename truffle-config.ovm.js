require('dotenv').config();
const mnemonic = process.env["MNEMONIC"];

const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  contracts_build_directory: './build',
  contracts_directory: './contracts',

  networks: {
    optimistic_mainnet: {
      network_id: 10,
      chain_id: 10,
      // gas: 6100000,
      // gas: 25000000,
      // gasPrice: 1000000, // 0.001 Gwei
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://optimism-rpc.publicnode.com", 0, 1);
      }
    }
  },

  mocha: {
    timeout: 100000
  },
  compilers: {
    solc: {
      version: "0.8.19",
      settings: {
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
    optimistic_etherscan: process.env.OPTIMISMSCAN_API
  }
}
