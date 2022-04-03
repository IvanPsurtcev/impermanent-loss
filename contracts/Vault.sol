//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    address public stablecoin;
    address public token1;
    address public token2;

    constructor(address _stablecoin, address _token1, address _token2) {
        stablecoin = _stablecoin;
        token1 = _token1;
        token2 = _token2;
    }
}