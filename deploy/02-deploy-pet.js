const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

const verify = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const Pet = await deploy("Pet", {
    from: deployer,
    args: [],
    log: true,
  });

  log("Pet Contract Deployed...");

  if (!developmentChains.includes(network.name)) {
    log("Verifying contract...");
    await verify(Pet.address, []);
  }
};
