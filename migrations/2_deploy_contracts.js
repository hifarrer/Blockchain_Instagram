const Decentragram = artifacts.require("Decentragram");

module.exports = function(deployer) {
  // this moves smart contracts from our computer to a blockchain
  deployer.deploy(Decentragram);
};
