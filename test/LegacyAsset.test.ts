import { expect } from "chai";
import { ethers } from "hardhat";
import { LegacyAsset } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { parseEther } from "ethers";

describe("LegacyAsset Contract", function () {
  let cash: LegacyAsset;
  let owner: HardhatEthersSigner;
  let user: HardhatEthersSigner;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    const CashFactory = await ethers.getContractFactory("LegacyAsset");
    cash = await CashFactory.connect(owner).deploy();
    await cash.waitForDeployment();
  });

  describe("LegacyAsset Test", function () {
    it("1 - Should constructor works expected", async function () {
      expect((await cash.connect(owner).balanceOf(owner.address))).to.equal(parseEther("1"))
    });

    it("2 - Should mint function works expected", async function () {
      const beforeBalance = await cash.connect(owner).balanceOf(owner.address)
      const beforeTotalSupply = await cash.connect(owner).totalSupply()
      const mintFunction = await cash.connect(owner).mint(owner.address, parseEther("100"))
      const expectedBalance = beforeBalance + parseEther("100")
      const expectedTotalSupply = beforeTotalSupply + parseEther("100")
      expect(await cash.connect(owner).balanceOf(owner.address)).to.equal(expectedBalance)
      expect(await cash.connect(owner).totalSupply()).to.equal(expectedTotalSupply)
    });

    it("3 - Should burnFrom function works expected", async function () {
      const beforeBalance = await cash.connect(owner).balanceOf(owner.address)
      const beforeTotalSupply = await cash.connect(owner).totalSupply()
      const approveFunction = await cash.connect(owner).approve(owner.address, parseEther("1"))
      const burnFromFunction = await cash.connect(owner).burnFrom(owner.address, parseEther("1"))
      const expectedBalance = beforeBalance - parseEther("1")
      const expectedTotalSupply = beforeTotalSupply - parseEther("1")
      expect(await cash.connect(owner).balanceOf(owner.address)).to.equal(expectedBalance)
      expect(await cash.connect(owner).totalSupply()).to.equal(expectedTotalSupply)
    });
  });
});