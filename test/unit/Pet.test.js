const { developmentChains } = require("../../helper-hardhat-config");
const { network, ethers } = require("hardhat");

const { expect } = require("chai");

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("Pet", async function () {
      let deployer,
        account,
        Pet,
        URI = "Test URI";

      beforeEach(async function () {
        [deployer, account] = await ethers.getSigners();

        Pet = await ethers.getContract("Pet", deployer.address);
      });

      it("deployed correctly", async function () {
        const lastTimestampt = await Pet.getLastTimestampt();
        console.log("Last timestampt: ", lastTimestampt.toString());
        expect(lastTimestampt.toString()).to.be.equal(
          Math.ceil(Date.now() / 1000).toString()
        );
      });

      it("should mint petNft", async function () {
        expect(await Pet.connect(account).mint(URI))
          .to.emit(Pet, "NFTMinted")
          .withArgs("1", Math.ceil(Date.now() / 1000).toString());
        expect(await Pet.getTokenId()).to.be.equal("1");
      });
    });
