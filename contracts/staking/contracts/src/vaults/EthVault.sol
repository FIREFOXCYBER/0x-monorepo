/*

  Copyright 2019 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;

import "@0x/contracts-erc20/contracts/src/interfaces/IEtherToken.sol";
import "@0x/contracts-utils/contracts/src/LibSafeMath.sol";
import "../interfaces/IEthVault.sol";
import "../immutable/MixinDeploymentConstants.sol";
import "./MixinVaultCore.sol";


/// @dev This vault manages WETH.
contract EthVault is
    IEthVault,
    IVaultCore,
    MixinDeploymentConstants,
    Ownable,
    MixinVaultCore
{
    using LibSafeMath for uint256;

    // mapping from Owner to WETH balance
    mapping (address => uint256) internal _balances;

    /// @dev Deposit an `amount` of WETH for `owner` into the vault.
    ///      The staking contract should have granted the vault an allowance
    ///      because it will pull the WETH via `transferFrom()`.
    ///      Note that this is only callable by the staking contract.
    /// @param owner Owner of the WETH.
    /// @param amount Amount of deposit.
    function depositFor(address owner, uint256 amount)
        external
        onlyStakingProxy
    {
        // Transfer WETH from the staking contract into this contract.
        IEtherToken(_getWETHAddress()).transferFrom(msg.sender, address(this), amount);
        // Credit the owner.
        _balances[owner] = _balances[owner].safeAdd(amount);
        emit EthDepositedIntoVault(msg.sender, owner, amount);
    }

    /// @dev Withdraw an `amount` of WETH to `msg.sender` from the vault.
    /// @param amount of WETH to withdraw.
    function withdraw(uint256 amount)
        external
    {
        _withdrawFrom(msg.sender, amount);
    }

    /// @dev Withdraw ALL WETH to `msg.sender` from the vault.
    function withdrawAll()
        external
        returns (uint256 totalBalance)
    {
        // get total balance
        address payable owner = msg.sender;
        totalBalance = _balances[owner];

        // withdraw WETH to owner
        _withdrawFrom(owner, totalBalance);
        return totalBalance;
    }

    /// @dev Returns the balance in WETH of the `owner`
    /// @return Balance in WETH.
    function balanceOf(address owner)
        external
        view
        returns (uint256)
    {
        return _balances[owner];
    }

    /// @dev Withdraw an `amount` of WETH to `owner` from the vault.
    /// @param owner of WETH.
    /// @param amount of WETH to withdraw.
    function _withdrawFrom(address payable owner, uint256 amount)
        internal
    {
        //Uupdate balance.
        _balances[owner] = _balances[owner].safeSub(amount);

        // withdraw WETH to owner
        IEtherToken(_getWETHAddress()).transfer(msg.sender, amount);

        // notify
        emit EthWithdrawnFromVault(msg.sender, owner, amount);
    }
}
