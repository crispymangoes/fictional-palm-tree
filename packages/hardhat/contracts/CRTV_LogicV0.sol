//SPDX-License-Identifier: GPL-2.0-only OR MIT

pragma solidity >=0.6.0;

import "./CRTV_TokenStorage.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CRTV_LogicV0 is ERC20Upgradeable, CRTV_TokenStorage, Ownable {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address public DAO; //An etherum address that represents a DAO


    event Mint(address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function inititialize(address _balances, address _allowances, string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) public CRTV_TokenStorage(_balances, _allowances) {

        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = initialSupply;
        Mint(msg.sender, _totalSupply);
    }
/*
    // Only the owner can mint new tokens
    function mint(address _to, uint256 _amount) public onlyOwner {
        return _mint(_to, _amount);
    }

    // Anyone can burn tokens
    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }

    function approve(address _spender, uint256 _value) public override returns (bool) {
        allowances.setAllowance(msg.sender, _spender, _value);
        return true;
    }
*/
    function transfer(address _to, uint256 _amount) public override returns (bool) {
        require(_to != address(0), "to address cannot be 0x0");
        require(_amount <= balanceOf(msg.sender), "not enough balance to transfer");
        balances.subBalance(msg.sender, _amount);
        balances.addBalance(_to, _amount);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool) {
        require(_amount <= allowance(_from, msg.sender), "not enough allowance to transfer");
        require(_to != address(0), "to address cannot be 0x0");
        require(_amount <= balanceOf(_from), "not enough balance to transfer");

        allowances.subAllowance((_from), msg.sender, _amount);
        balances.addBalance(_to, _amount);
        balances.subBalance(_from, _amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }
/*
    function balanceOf(address who) public override view returns (uint256) {
        return balances.balanceOf(who);
    }
    // Think allowances show you how much you can send to someone
    function allowance(address owner, address spender) public override view returns (uint256) {
        return allowances.allowanceOf(owner, spender);
    }

    function totalSupply() public override view returns (uint256) {
        return balances.totalSupply();
    }


    function _burn(address _tokensOf, uint256 _amount) internal override {
        require(_amount <= balanceOf(_tokensOf), "not enough balance to burn");

        balances.subBalance(_tokensOf, _amount);
        balances.subTotalSupply(_amount);
        emit Burn(_tokensOf, _amount);
        emit Transfer(_tokensOf, address(0), _amount);
    }

    function _mint(address _to, uint256 _amount) internal override {
        balances.addTotalSupply(_amount);
        balances.addBalance(_to, _amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
    }
*/
}