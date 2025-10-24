import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";
import stylistic from '@stylistic/eslint-plugin'


export default defineConfig([
  // Ignore files from .eslintignore
  {
    ignores: [
      "dist/",
      "webpack.config.js",
      "lib/",
      "out/",
      "cache/",
    ],
  },
  // Base config for all JS/MJS/CJS files
  {
    files: ["**/*.{js,mjs,cjs}"],
    plugins: { js },
    extends: ["js/recommended"],
    rules: {
      "no-unexpected-multiline": "off", // Turn off rule that conflicts with Prettier
    },
  },
  // Config for OpenZeppelin files (Node.js environment)
  {
    files: ["lib/openzeppelin-contracts/**/*.js"],
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.mocha,
        artifacts: "readonly",
        extendEnvironment: "readonly",
        expect: "readonly",
      },
    },
  },
  // Config for ES Modules
  {
    files: [
      "commitlint.config.js",
      "lib/openzeppelin-contracts/certora/run.js",
    ],
    languageOptions: { sourceType: "module" },
  },
  // stylistic : https://eslint.style/rules
  {
    plugins: {
      '@staylistic': stylistic
    },
    rules: {
      '@stylistic/indent': ['error', 2],
    }
  }
]);
