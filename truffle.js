var HDWalletProvider = require('truffle-hdwallet-provider')

// Be sure to match this mnemonic with that in Ganache!
var mnemonic = ''

module.exports = {
  networks: {
    development: {
      provider: function () {
        return new HDWalletProvider(mnemonic, 'http://127.0.0.1:8545/', 0, 10)
      },
      network_id: '*',
      gas: 1999999
    }
  }
}
