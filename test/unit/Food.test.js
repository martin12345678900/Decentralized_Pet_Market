const { developmentChains } = require("../../helper-hardhat-config");
const { network, ethers } = require("hardhat");

const { expect } = require("chai");

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("Food", function () {
      let Food;
      beforeEach(async function () {
        Food = await ethers.getContract("Food");
      });

      it("correctly deployed", async function () {
        expect(await Food.name()).to.be.equal("Food Token");
        expect(await Food.symbol()).to.be.equal("FTN");
      });
    });
