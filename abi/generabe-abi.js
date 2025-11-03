const fs = require('fs');
const path = require('path');
const solc = require('solc');

// --- Configuration ---
const PROJECT_ROOT = path.join(__dirname); // Assuming script is run from project root
const CONTRACTS_DIR = path.join(PROJECT_ROOT, 'src'); // Typical Foundry source dir
const OUTPUT_DIR = path.join(PROJECT_ROOT, 'abi-output');
const TARGET_FILENAME = 'MyContract.sol'; // <-- CHANGE THIS to your contract file
const TARGET_CONTRACT_NAME = 'MyContract'; // <-- CHANGE THIS to the contract name inside the file
// ---------------------

/**
 * Reads all files and directory structure in the `lib` folder to generate remappings.
 * This is a simplified version; Foundry generates remappings from `foundry.toml` and the directory.
 * @returns {string[]} An array of remapping strings (e.g., '@openzeppelin/=lib/openzeppelin-contracts/').
 */
function getFoundryRemappings() {
    // 1. Check for the remappings.txt file (often created by 'forge remappings > remappings.txt')
    const remappingsPath = path.join(PROJECT_ROOT, 'remappings.txt');
    if (fs.existsSync(remappingsPath)) {
        console.log('✅ Found remappings.txt. Using remappings from file.');
        return fs.readFileSync(remappingsPath, 'utf8')
            .split('\n')
            .filter(line => line.trim() !== '' && !line.startsWith('#'));
    }

    // 2. Fallback to common library paths (useful if remappings.txt isn't present)
    const remappings = [
        // Standard forge-std remapping
        'forge-std/=lib/forge-std/src/', 
        // Example for OpenZeppelin if installed as a git submodule
        '@openzeppelin/=lib/openzeppelin-contracts/contracts/' 
    ];

    console.warn('⚠️ remappings.txt not found. Using hardcoded common remappings. This may fail if your project uses different ones.');
    return remappings;
}

/**
 * Compiles the target contract using the Standard JSON Input format with remappings.
 */
function compileContract() {
    const remappings = getFoundryRemappings();
    const targetPath = path.join(CONTRACTS_DIR, TARGET_FILENAME);
    const sourceCode = fs.readFileSync(targetPath, 'utf8');

    // Create a mapping of all source files required for compilation (including imports)
    const sources = {
        [TARGET_FILENAME]: { content: sourceCode }
    };
    
    // The Standard JSON Input structure for solc
    const input = {
        language: 'Solidity',
        sources: sources,
        settings: {
            remappings: remappings, // <-- The critical part for Foundry imports
            optimizer: { enabled: true, runs: 200 }, // Match typical Foundry settings
            outputSelection: {
                '*': {
                    '*': ['abi', 'evm.bytecode.object'], // Request ABI and bytecode
                },
            },
        },
    };

    // Use an import callback function for solc to resolve the imported files (with remappings)
    function findImports(importPath) {
        // Apply remappings
        for (const remap of remappings) {
            const [prefix, target] = remap.split('=');
            if (importPath.startsWith(prefix)) {
                // Construct the local path based on the remapping
                const localPath = path.join(PROJECT_ROOT, target, importPath.substring(prefix.length));
                if (fs.existsSync(localPath)) {
                    console.log(`[Import] Resolved ${importPath} to ${localPath}`);
                    return { contents: fs.readFileSync(localPath, 'utf8') };
                }
            }
        }
        
        // Fallback to relative path resolving within the project directory
        const fallbackPath = path.join(path.dirname(targetPath), importPath);
        if (fs.existsSync(fallbackPath)) {
            // console.log(`[Import] Resolved ${importPath} to ${fallbackPath}`);
            return { contents: fs.readFileSync(fallbackPath, 'utf8') };
        }

        console.error(`[Import Error] Could not find imported file: ${importPath}`);
        return { error: 'File not found' };
    }


    console.log(`\nCompiling contract: ${TARGET_FILENAME} with ${remappings.length} remappings...`);
    
    // Compile the contract using the JSON input and the import callback
    const output = JSON.parse(solc.compile(JSON.stringify(input), { import: findImports }));

    // Handle and report compilation errors/warnings
    if (output.errors) {
        const errors = output.errors.filter(e => e.type === 'Error');
        if (errors.length > 0) {
            console.error('\n❌ Compilation Errors Found:');
            errors.forEach(e => console.error(e.formattedMessage));
            throw new Error('Contract compilation failed.');
        }
        output.errors.forEach(e => console.warn(`\n⚠️ Warning: ${e.formattedMessage}`));
    }

    // Extract the ABI and save it
    const contract = output.contracts[TARGET_FILENAME][TARGET_CONTRACT_NAME];
    if (!contract) {
        throw new Error(`Contract '${TARGET_CONTRACT_NAME}' not found in the compilation output.`);
    }

    const abi = contract.abi;
    
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }

    const abiOutputPath = path.join(OUTPUT_DIR, `${TARGET_CONTRACT_NAME}.abi.json`);
    fs.writeFileSync(abiOutputPath, JSON.stringify(abi, null, 2), 'utf8');

    console.log(`\n✅ ABI successfully generated and saved to: ${abiOutputPath}`);
}

try {
    compileContract();
} catch (error) {
    console.error(`\n❌ Failed to generate ABI: ${error.message}`);
    process.exit(1);
}