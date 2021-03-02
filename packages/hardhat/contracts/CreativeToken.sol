// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CreativeVendor.sol";

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract CreativeToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, CreativeVendor {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address public DAO; //An etherum address that represents a DAO


    //mapping(address => uint) public balanceOf;
    //mapping(address => mapping(address => uint)) public allowance;

    function initialize(string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) public initializer {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = initialSupply;

        // Create the initial supply of 980,000,000 CRTV
        _mint(msg.sender, _totalSupply); // I think _mint also checks to make sure only the owner can call that function

    }

    // The onlyOwner makes it so only the owner of this contract can call this function
    // In the future this should only be callable by a smart ocntract that represents a DAO
    // Figure out how to make this function only callable with multisig
    function generateNew(uint256 amountToGenerate) public onlyOwner {
        // don't think this would just call mint since the owner should be able to do that anyways, instead I imagine it would call other functions it needs to when this is happening
        _mint(msg.sender, amountToGenerate);
    }
}