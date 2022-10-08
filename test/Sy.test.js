const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("solidity-yul", () => {
  let a, sy;
  beforeEach(async () => {
    const SolidityYul = await ethers.getContractFactory("SolidityYul");
    sy = await SolidityYul.deploy();
    await sy.deployed();
    const A = await ethers.getContractFactory("A");
    a = await A.deploy();
    await a.deployed();
  });
  it("get number", async () => {
    const [a, b] = await sy.getUint128Numbers();
    expect(a).to.equal("12");
    expect(b).to.equal("7");
  });
  it("add", async () => {
    expect(await sy.add(2, 4)).to.equal(6);
  });
  it("set k", async () => {
    await sy.setK(3);
  });
  it("map", async () => {
    await sy.setMapNumber(1, 7);
    expect(await sy.readMap(1)).to.equal("7");
  });
  it("array", async () => {
    expect(await sy.readFromArray(2)).to.equal("9");
  });
  it("get string", async () => {
    const res = await sy.getString();
    console.log(res);
  });
  it("get number", async () => {
    const [a, b] = await sy.getNumber();
    expect(a).to.equal(0);
    expect(b).to.equal(0);
  });
  it("set number", async () => {
    await sy.setNumber(4);
    const [, b] = await sy.getNumber();
    expect(b).to.equal(4);
  });
  it("get numbers", async () => {
    const [a, b] = await sy.getNumbers();
    expect(a).to.equal(2);
    expect(b).to.equal(7);
  });
  describe("external calls", () => {
    it("read num", async () => {
      const num = await sy.readNumber(a.address);
      console.log(num.toString());
    });
    it("write num", async () => {
      const tx = await sy.writeNumber(a.address, 25);
      await tx.wait();
      expect(await a.z()).to.be.equal("25");
    });
    it("dynamic", async () => {
      expect(await sy.readDynamicDataLength(a.address, 1)).to.equal("0x00");
    });
  });
});
