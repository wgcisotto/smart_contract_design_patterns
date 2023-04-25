import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("@nomiclabs/hardhat-ethers")
require("@openzeppelin/hardhat-upgrades")

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  paths: { tests: "tests" }
};

export default config;
