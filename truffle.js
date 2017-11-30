module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    ganache: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    },
    kovan: {
      host: "localhost",
      port: 8545,
      network_id: "42", // Match any network id
      from: '0x008B6b70eB22102FeD02C7A82921839b5D0c2Cb7'
    }
  }
};
