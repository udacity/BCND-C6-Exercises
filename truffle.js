var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "fade attack defense sound nothing riot rug aim cigar embody until check";

module.exports = {
  networks: {
    development: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:9545/", 0, 10);
      },
      network_id: '*',
      gas: 4500000
    }
  },
  compilers: {
    solc: {
      version: "^0.4.25"
    }
  }
};