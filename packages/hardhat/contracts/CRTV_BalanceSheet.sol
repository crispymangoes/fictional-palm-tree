//SPDX-License-Identifier: GPL-2.0-only OR MIT

pragma solidity >=0.6.0;

//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CRTV_BalanceSheet is Ownable {
    //using SafeMath for uint256;

    mapping (address => uint256) public balanceOf;
    uint256 public totalSupply;

    function addBalance(address _addr, uint256 _value) public onlyOwner {
        balanceOf[_addr] = balanceOf[_addr].add(_value);
    }

    function subBalance(address _addr, uint256 _value) public onlyOwner {
        balanceOf[_addr] = balanceOf[_addr].sub(_value);
    }
    
    function setBalance(address _addr, uint256 _value) public onlyOwner {
        balanceOf[_addr] = _value;
    }

    function addTotalSupply(uint256 _value) public onlyOwner {
        totalSupply = totalSupply.add(_value);
    }

    function subTotalSupply(uint256 _value) public onlyOwner {
        totalSupply = totalSupply.sub(_value);
    }

    function setTotalSupply(uint256 _value) public onlyOwner {
        totalSupply = _value;
    }
}

