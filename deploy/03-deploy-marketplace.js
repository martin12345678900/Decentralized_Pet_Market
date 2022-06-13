const { ethers, network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

const verify = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const PetContract = await ethers.getContract("Pet");

  const Marketplace = await deploy("Marketplace", {
    from: deployer,
    args: [PetContract.address],
    log: true,
  });

  if (!developmentChains.includes(network.name)) {
    log("Verifying contract...");
    await verify(Marketplace.address, [PetContract.address]);
  }

  log("Marketplace Contract Deployed...");
};
