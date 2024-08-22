const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config()

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a managed Ganache instance for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    base: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, `https://base.publicnode.com`),
      network_id: 8453,
      gas: 7910000,
      gasPrice: 100000057, // 0.1 GWei
      confirmations: 2,
      timeoutBlocks: 200,
      networkCheckTimeout: 1000000,
      skipDryRun: true,
      verify: {
        apiUrl: 'https://api.basescan.org/api',
        apiKey: process.env.BASESCAN_ABI,
        explorerUrl: 'https://docs.basescan.org/address',
      },
    },
    bsc: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, `https://rpc.ankr.com/bsc`),
      network_id: 56,
      gas: 5500000,          // Gas sent with each transaction (default: ~6700000)
      gasPrice: 1000000000,  // 3 gwei (in wei) (default: 100 gwei)
      confirmations: 2,
      timeoutBlocks: 200,
      networkCheckTimeout: 10000,
      skipDryRun: true
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.19",      // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        // evmVersion: "byzantium"
      }
    }
  },

  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  //
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  //
  // After you backed up your artifacts you can utilize db by running migrate as follows:
  // $ truffle migrate --reset --compile-all
  //
  // db: {
  //   enabled: false,
  //   host: "127.0.0.1",
  //   adapter: {
  //     name: "indexeddb",
  //     settings: {
  //       directory: ".db"
  //     }
  //   }
  // }
};
