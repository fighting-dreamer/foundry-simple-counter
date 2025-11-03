//  Generate ABI

const fs = require('fs')
const path = require('path')
const solc = require("solc")
const prompt = require('prompt-sync')({ sigint: true });
const { exec } = require('child_process');


const PROJECT_ROOT = process.cwd(); // Use the current working directory
const CONTRACT_DIR = path.join(PROJECT_ROOT, "src");
const FOUNDRY_OUTPUT_DIR = path.join(PROJECT_ROOT, "out");
const FILE_NAME = prompt("whats the file ?");
const TARGET_CONTRACT = prompt("whats the contract name");
const TARGET_CONTRACT_PATH = path.join(FOUNDRY_OUTPUT_DIR, `${FILE_NAME}.sol`);
const TARGET_CONTRACT_FILE = path.join(TARGET_CONTRACT_PATH, `${TARGET_CONTRACT}.json`);
const usingFoundry = prompt("is using foundry ?") == "true";
const usingHardHat = false
const local_solc = false
// you given solidity code, you have to build the abi from that.
// code will have imports
// the files are suppose to be there in relevant directories
// if using foundry, then there are remappings.

if (usingFoundry) {
    console.log(PROJECT_ROOT);
    console.log(CONTRACT_DIR);
    console.log(FOUNDRY_OUTPUT_DIR);
    console.log(TARGET_CONTRACT);
    console.log(TARGET_CONTRACT_PATH)
    console.log(TARGET_CONTRACT_FILE)
    console.log(usingFoundry);
    // run the forge build command
    const command = "forge build";
    // child process running the command :
    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });

    const outputFile = fs.readFileSync(TARGET_CONTRACT_FILE, 'utf8');
    console.log(outputFile);
    const info = JSON.parse(outputFile)
    console.log(info)
} else if (usingHardHat) {
    // read from artifacts/src/<file_name>/<contract_name>.json
    // example : PWD/artifacts/src/SimpleCounter/SimpleCounterV2.json
    // notice, you dont have ".sol" in hte file name.
    // inside the file : there is a "abi" key.
} else if (local_solc) {

}