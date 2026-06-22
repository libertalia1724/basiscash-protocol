import { expect } from "chai";
import { ethers } from "hardhat";
import { MockLegacyOperator } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("MockLegacyOperator Contract", function () {
  let mockOperator: MockLegacyOperator;
  let owner: HardhatEthersSigner;
  let user: HardhatEthersSigner;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    const MockOperatorFactory = await ethers.getContractFactory("MockLegacyOperator");
    mockOperator = await MockOperatorFactory.connect(owner).deploy();
    await mockOperator.waitForDeployment();
  });

  describe("Operator Test", function () {
    it("1 - Should return the correct operator address", async function () {
      const operatorFunc = await mockOperator.connect(user).operator();
      expect(operatorFunc).to.equal(owner.address);
    });

    it("2 - Should isOperator return true for operator", async function () {
      const isOperatorFunc = await mockOperator.connect(owner).isOperator();
      expect(isOperatorFunc).to.equal(true);
    });

    it("3 - Should isOperator return false for non-operator", async function () {
      const isOperatorFunc = await mockOperator.connect(user).isOperator();
      expect(isOperatorFunc).to.equal(false);
    });

    it("4 - Should revert on unauthorized access", async function () {
      await expect(
        mockOperator.connect(user).transferOperator(user.address)
      ).to.be.revertedWithCustomError(mockOperator, "OwnableUnauthorizedAccount")
        .withArgs(user.address);
    });

    it("5 - Should revert on zero address", async function () {
      await expect(
        mockOperator.connect(owner).transferOperator(ethers.ZeroAddress)
      ).to.be.revertedWith("operator: zero address given for new operator");
    });

    it("6 - Should emit OperatorTransferred on transfer", async function () {
      await expect(
        mockOperator.connect(owner).transferOperator(user.address)
      ).to.emit(mockOperator, "OperatorTransferred")
        .withArgs(ethers.ZeroAddress, user.address);
    });

    it("7 - Should revert onlyOperator function for non-operator", async function () {
      await expect(
        mockOperator.connect(user).onlyOperatorFunction()
      ).to.be.revertedWith("operator: caller is not the operator");
    });

    it("8 - Should allow operator to call onlyOperator function", async function () {
      await expect(
        mockOperator.connect(owner).onlyOperatorFunction()
      ).to.not.be.reverted;

      expect(await mockOperator.operatorCalled()).to.equal(true);
    });
  });
});