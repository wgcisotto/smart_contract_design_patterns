import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
 
let TransparentProxy, ProxyAdmin, CarV1, CarV2;
 
describe('Proxy Pattern (Transparent Proxy)', function () {
  
  async function deployment() {
    TransparentProxy = await ethers.getContractFactory("Proxy");
    const proxyContract = await TransparentProxy.deploy();

    ProxyAdmin = await ethers.getContractFactory("ProxyAdmin");
    const proxyAdminContract = await ProxyAdmin.deploy();

    CarV1 = await ethers.getContractFactory("CarV1");
    const carV1 = await CarV1.deploy();

    return {proxyContract, proxyAdminContract, carV1};
  }

  describe("Deployment", function () {
    it('Proxy should be initialized', async function () {
      const { proxyContract } = await loadFixture(deployment);
      expect(proxyContract.address).to.not.equal(null);
      expect(proxyContract.address).to.not.equal("");
    });
    it('Proxy Admin should be initialized', async function () {
      const { proxyAdminContract } = await loadFixture(deployment);
      expect(proxyAdminContract.address).to.not.equal(null);
      expect(proxyAdminContract.address).to.not.equal("");
    });
    it('Implementation V1 should be initialized', async function () {
      const { carV1 } = await loadFixture(deployment);
      expect(carV1.address).to.not.equal(null);
      expect(carV1.address).to.not.equal("");
    });
    it('Deployer should be the admin of the Proxy', async function () {
      const { proxyAdminContract } = await loadFixture(deployment);
      // Contracts are deployed using the first signer/account by default
      const [owner] = await ethers.getSigners();
      expect(proxyAdminContract.getProxyAdmin).to.not.equal(owner.address);
    });
    it('Proxy Implementation Should be 0x0 Address', async function () {
      const { proxyAdminContract, proxyContract } = await loadFixture(deployment);
      // Contracts are deployed using the first signer/account by default
      const [owner] = await ethers.getSigners();
      await proxyContract.connect(owner).changeAdmin(proxyAdminContract.address);
      expect(proxyAdminContract.getProxyImplementation).to.not.equal("0x0000000000000000000000000000000000000000");
    });
  });

  describe("Setup", function () {
    describe("Proxy Admin Setup", function () {
      it('Deployer should be able to grant admin access to ProxyAdmin', async function () {
        const { proxyContract, proxyAdminContract } = await loadFixture(deployment);
        // Contracts are deployed using the first signer/account by default
        const [owner] = await ethers.getSigners();
        await proxyContract.connect(owner).changeAdmin(proxyAdminContract.address);
        expect(proxyAdminContract.getProxyAdmin).to.not.equal(proxyAdminContract.address);
      });
    });
    describe("Proxy Implementation Setup", function () {
      it('ProxyAdmin should be able upgrade the implementation contract', async function () {
        const { proxyContract, proxyAdminContract } = await loadFixture(deployment);
        // Contracts are deployed using the first signer/account by default
        const [owner] = await ethers.getSigners();
        await proxyAdminContract.connect(owner).changeProxyAdmin(proxyContract.address, proxyAdminContract.address);
        expect(proxyAdminContract.getProxyAdmin).to.not.equal(proxyAdminContract.address);
      });
    });
  });

  describe("Upgrade", function () {
    it('Proxy should be initialized', async function () {
      // Test if the returned value is the same one
      // Note that we need to use strings to compare the 256 bit integers
     // expect((await boxContract.retrieve()).toString()).to.equal('42');
    });
    // Test case
    it('retrieve returns a value previously initialized', async function () {
      // Test if the returned value is the same one
      // Note that we need to use strings to compare the 256 bit integers
     // expect((await boxContract.retrieve()).toString()).to.equal('42');
    });
  });

});