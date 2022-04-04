//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultFactory {
    function createVaultFactory(IERC20 _stablecoin, address _token1, address _token2) public returns (address) {
        require(_token1 != address(0), "Invalid token address");
        require(_token2 != address(0), "Invalid token address");
        
        Vault vault = new Vault(_stablecoin, _token1, _token2);
        return address(vault);
    }
}