const { ethers } = require('ethers');
const compiledJson = require('../artifacts/src/SimpleCounter.sol/SimpleCounterV2.json')
// const {ethers} = require('ethers')
console.log(JSON.stringify(compiledJson.abi));
// 1. The ABI (Application Binary Interface) for your contract.
// This is the JSON array you provided.
const contractAbi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"OwnableInvalidOwner","type":"error"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"OwnableUnauthorizedAccount","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"inputs":[],"name":"decrement","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getNumber","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"increment","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}];

// 2. The address of your deployed contract.
// You need to replace this with the actual address after you deploy it.
const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Example address

// 3. Connect to an Ethereum node.
// This connects to a local node (like Anvil, Hardhat, or Ganache) by default.
// For a real network, you'd use a provider URL, e.g., from Infura or Alchemy.
const provider = new ethers.JsonRpcProvider();

// 4. Get a signer to send transactions.
// This gets the first account from the connected node.
const signer = provider.getSigner();

// 5. Create a contract instance.
// We connect it with the signer so we can send transactions.
const contract = new ethers.Contract(contractAddress, contractAbi, signer);

async function main() {
    console.log("Interacting with contract at:", contract.address);

    // --- Making a read-only call ---
    // We don't need a signer for this, just a provider.
    // The `getNumber` function is a 'view' function.
    try {
        console.log("\nReading the current number...");
        const currentNumber = await contract.getNumber();
        console.log("Current number is:", currentNumber.toString());
    } catch (error) {
        // console.error("Error reading number:", error.message);
    }

    // --- Making a state-changing call (a transaction) ---
    // The `increment` function is a 'nonpayable' function, so it costs gas.
    // We need a signer to send this transaction.
    try {
        console.log("\nSending transaction to increment the number...");
        const tx = await contract.increment()
        console.log("Transaction sent! Hash:", tx.hash);

        // Wait for the transaction to be mined
        await tx.wait();
        console.log("Transaction confirmed!");

        const newNumber = await contract.getNumber();
        console.log("New number is:", newNumber.toString());
    } catch (error) {
        // console.error("Error incrementing number:", error.message);
    }
}

main().catch(console.error);
