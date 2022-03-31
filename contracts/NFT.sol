//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT is ERC1155 {

    address public asset1;
    address public asset2;
    address public collateralAsset;
    address public owner;

    uint256 public relPrice1;
    uint256 public relPrice2;
    uint256 public collateralVolume;

    constructor(
        address _asset1,
        address _asset2,
        address _collateralAsset,
        uint256 _relPrice1,
        uint256 _relPrice2,
        uint256 _collateralVolume
    ) ERC1155("https://nft.com") {
        asset1 = _asset1;
        asset2 = _asset2;
        collateralAsset = _collateralAsset;
        relPrice1 = _relPrice1;
        relPrice2 = _relPrice2;
        collateralVolume = _collateralVolume;
        owner = msg.sender;
    }
}