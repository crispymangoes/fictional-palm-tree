/* eslint no-use-before-define: "warn" */

const fs = require("fs");
const chalk = require("chalk");
const { config, ethers, tenderly, artifacts, upgrades } = require("hardhat");
const { utils } = require("ethers", "upgrades");
const R = require("ramda");


//const CreativeToken = artifacts.require("../contracts/CreativeToken.sol");

const main = async () => {

  //----------------------Deploy Creative Token---------------------------------------------------
  console.log("\n\n 📡 Deploying...\n");

  const CreativeToken = await ethers.getContractFactory("CreativeToken");
  const creatvieToken = await upgrades.deployProxy(CreativeToken, "Creative Token", "CRTV", 18, 1000) // <-- add in constructor args like line 19 vvvv
  await creatvieToken.deployed();
  console.log(
    " 💾  Artifacts (address, abi, and args) saved to: ",
    chalk.blue("packages/hardhat/artifacts/"),
    "\n\n"
  );

 //----------------------Deploy Creative Vendor Contract ---------------------------------------------------
 console.log("\n\n 📡 Deploying...\n");


 const creativeVendor = await deploy("CreativeVendor", creatvieToken.address) // <-- add in constructor args like line 19 vvvv

 console.log(
   " 💾  Artifacts (address, abi, and args) saved to: ",
   chalk.blue("packages/hardhat/artifacts/"),
   "\n\n"
 );

  // -------------------------------------Deploy AaveApe-----------------------------------------------


  console.log("\n\n 📡 Deploying...\n");

  let mainnetConfig = {
    lendingPoolAddressesProvider: "0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5",
    uniswapRouterAddress: "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
  }

  // Kovan Aave has a dedicated mock Uniswap contract... https://kovan.etherscan.io/address/0xC18451d36aA370fDACe8d45839bF975F48f7AEa1#readContract
  let kovanConfig = {
    lendingPoolAddressesProvider: "0x88757f2f99175387ab4c6a4b3067c77a695b0349",
    uniswapRouterAddress: "0xfcd87315f0e4067070ade8682fcdbc3006631441"
  }

  let deployConfig = (process.env.HARDHAT_NETWORK === 'kovan' || config.defaultNetwork === 'kovan') ? kovanConfig : mainnetConfig

  const aaveApe = await deploy("AaveApe",[deployConfig.lendingPoolAddressesProvider, deployConfig.uniswapRouterAddress])

  console.log(
    " 💾  Artifacts (address, abi, and args) saved to: ",
    chalk.blue("packages/hardhat/artifacts/"),
    "\n\n"
  );
};

const deploy = async (contractName, _args) => {
  console.log(` 🛰  Deploying: ${contractName}`);

  const contractArgs = _args || [];
  const contractArtifacts = await ethers.getContractFactory(contractName);
  const deployed = await contractArtifacts.deploy(...contractArgs);
  const encoded = abiEncodeArgs(deployed, contractArgs);
  fs.writeFileSync(`artifacts/${contractName}.address`, deployed.address);

  console.log(
    " 📄",
    chalk.cyan(contractName),
    "deployed to:",
    chalk.magenta(deployed.address),
  );

  if (!encoded || encoded.length <= 2) return deployed;
  fs.writeFileSync(`artifacts/${contractName}.args`, encoded.slice(2));

  return deployed;
};

// ------ utils -------

// abi encodes contract arguments
// useful when you want to manually verify the contracts
// for example, on Etherscan
const abiEncodeArgs = (deployed, contractArgs) => {
  // not writing abi encoded args if this does not pass
  if (
    !contractArgs ||
    !deployed ||
    !R.hasPath(["interface", "deploy"], deployed)
  ) {
    return "";
  }
  const encoded = utils.defaultAbiCoder.encode(
    deployed.interface.deploy.inputs,
    contractArgs
  );
  return encoded;
};

// checks if it is a Solidity file
const isSolidity = (fileName) =>
  fileName.indexOf(".sol") >= 0 && fileName.indexOf(".swp") < 0;

const readArgsFile = (contractName) => {
  let args = [];
  try {
    const argsFile = `./contracts/${contractName}.args`;
    if (!fs.existsSync(argsFile)) return args;
    args = JSON.parse(fs.readFileSync(argsFile));
  } catch (e) {
    console.log(e);
  }
  return args;
};




main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
