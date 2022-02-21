require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.10",
  networks: {
		mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/WBrLcdUyRyYchJlKEshkx_5ZstUzz9Yc",
      accounts: ["abbce15fdb248a107d0e2a3e704ce73ff67c53ca1c6f6ccd897667a34cf751fa"],
		}
  }
};