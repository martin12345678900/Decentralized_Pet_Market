const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

const verify = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const Food = await deploy("Food", {
    from: deployer,
    args: [],
    log: true,
  });

  log("Food Contract Deployed...");

  if (!developmentChains.includes(network.name)) {
    log("Verifying contract...");
    await verify(Food.address, []);
  }
};
