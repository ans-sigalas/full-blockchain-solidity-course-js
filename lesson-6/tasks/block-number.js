const { task } = require("hardhat/config")

task("block-number", "Prints the current block number").setAction(
    // This is an anonymous function
    async (taskArgs, hre) => {
        // hre = hardhat runtime environment
        const blockNumber = await hre.ethers.provider.getBlockNumber()
        console.log(`Current block number: ${blockNumber}`)
    }
)
