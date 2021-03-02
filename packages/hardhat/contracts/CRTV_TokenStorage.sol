//SPDX-License-Identifier: GPL-2.0-only OR MIT

pragma solidity >=0.6.0;
import "./CRTV_AllowanceSheet.sol";
import "./CRTV_BalanceSheet.sol";


contract CRTV_TokenStorage {
    CRTV_BalanceSheet public balances;
    CRTV_AllowanceSheet public allowances;

    constructor (address _balances, address _allowances) public {
        balances = CRTV_BalanceSheet(_balances);
        allowances = CRTV_AllowanceSheet(_allowances);
    }

    function claimBalanceOwnership() public {
        balances.claimOwnership();
    }

    function claimAllowanceOwnership() public {
        allowances.claimOwnweship();
    }
}