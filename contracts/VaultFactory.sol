//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";

contract VaultFactory {
    function createVaultFactory(address _stablecoin, address _token1, address _token2) public returns (address) {
        require(_token1 != address(0), "Invalid token address");
        require(_token2 != address(0), "Invalid token address");
        require(_stablecoin != address(0), "Invalid stablecoin address");
        
        Vault vault = new Vault(_stablecoin, _token1, _token2);
        return address(vault);
    }
}