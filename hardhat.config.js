require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");

/** @type import('hardhat/config').HardhatUserConfig */
// const ALCHEMY_API_KEY = "Japd4jMfawgqY0HuVrZlKNlAMCDEplKW";
const PRIVATE_KEY = "71550863537fa9983432da22ac6f2867d819f921525f2beef4a3d68aca5f33da";

module.exports = {
  solidity: "0.8.24",
  networks : {
    holesky : {
      // url : `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      url:`https://eth-holesky.public.blastapi.io`,
      accounts : [`${PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: "Y6PMZSW9N93SV5ZHMTMXXX4FJRAVMEZ7KC"
  },
  sourcify: {
    enabled: true
  },
};
