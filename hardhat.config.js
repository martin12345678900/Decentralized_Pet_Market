require("hardhat-deploy");
require("dotenv").config();
require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
    },
    rinkeby: {
      url: process.env.RINKEBY_RPC_URL,
      accounts: [process.env.ACCOUNT_PRIVATE_KEY],
      chainId: 4,
      saveDeployments: true,
      blockConfirmations: 6,
    },
  },
};
