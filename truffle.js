var HDWalletProvider = require("truffle-hdwallet-provider");

// Be sure to match this mnemonic with that in Ganache!
var mnemonic = "globe dice tongue comfort bike purse special taxi spoon cream biology scorpion";

module.exports = {
  compilers: {
    solc: {
      version: "^0.4.25"
    }
  },
  networks: {
    development: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545/", 0, 10);
      },
      network_id: '*',
    }
  }
};