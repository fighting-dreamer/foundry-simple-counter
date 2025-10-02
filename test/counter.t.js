const {expect} = require( 'chai');
const hre = require( 'hardhat');

const {loadFixture} = require('@nomicfoundation/hardhat-toolbox/network-helpers');

describe("creating contract", function() {
    async function deployContractFixture() {
        const [account, otherAccount] = await hre.ethers.getSigners();

        const contratFactory = await hre.ethers.getContractFactory("SimpleCounterV1");
        const deployContract = await contratFactory.deploy();
        deployContract.waitForDeployment();

        const contractAddress = deployContract.target;
        return {
            account,
            otherAccount,
            contratFactory,
            deployContract,
            contractAddress,
        }
    }

    describe("checking deployment", async function() {
        it("check increment", async function() {
            const {deployContract, otherAccount} = await loadFixture(deployContractFixture);
            
            const beforeVal = await deployContract.getNumber();
            console.log("Counter value (before) : ", beforeVal); 
            
            await deployContract.increment();

            const expected = beforeVal + 1;

            const got = await deployContract.getNumber();
            expect(got).is.equal(expect);
        })
    })
})

