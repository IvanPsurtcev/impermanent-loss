//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";
import "./interfaces/INFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// не хотел до последнего наследовать NFT, но не знаю как по-другому использовать mint оттуда

contract Vault is NFT {
    using SafeERC20 for IERC20;

    IERC20 public stablecoin;
    address public token1;
    address public token2;

    mapping(address => uint256) public NFTids;
    mapping(address => uint256) public collaterals;

    // здесь вместо захардкоженных цифр должны быть взяты значения с оракулов, но как это сделать не знаю
    constructor(IERC20 _stablecoin, address _token1, address _token2) NFT(_token1, _token2, _stablecoin, 1, 1, 10) { 
        stablecoin = _stablecoin;
        token1 = _token1;
        token2 = _token2;
    }

    function depositCollateral(uint256 collateralValue) external returns (uint256){
        //require(collateralValue > 1000, "Collateral value too low!");
        stablecoin.safeTransferFrom(msg.sender, address(this), collateralValue);
        collaterals[msg.sender] = collateralValue;
        uint256 nftId;
        mint(msg.sender, nftId, 1, abi.encodePacked(msg.sender)); 
        NFTids[msg.sender] = nftId;
        nftId += 1;
        return NFTids[msg.sender];
    }

    function redeemCollateral(uint256 nftId) external returns (uint256) {
        require(NFTids[msg.sender] == nftId, "Other owner");
        if(!_checkStatusNFT(nftId)) 
            // не понимаю зачем нам отправлять NFT в волт, и как это реализовать?
            return _checkNAV(nftId);
    }

    function liquidatePosition(uint256 nftId) external {
        require(NFTids[msg.sender] == nftId, "Other owner");
        require(_checkStatusNFT(nftId) == true, "Not available for liquidation");
        uint256 netValue = _checkNAV(nftId);
        stablecoin.safeTransferFrom(address(this), msg.sender, netValue); // интересно узнать как правильно
    }

    function _checkNAV(uint256 nftId) private returns (uint256) {
        uint256 impermanentLoss = _calculateImpermanentLoss(nftId);
        uint256 netValue = collaterals[msg.sender] - impermanentLoss;
        return netValue;
    }

    function _checkStatusNFT(uint256 nftId) private returns (bool) {
        uint256 netValue = _checkNAV(nftId) * 100;
        uint256 collateral = collaterals[msg.sender] * 100;
        if (netValue / collateral < 20) { //есть вопросы по округлению
            return true;
        } else {
            return false;
        }
    }

    function _calculateImpermanentLoss(uint256 nftId) private returns (uint256) {
        // не знаю как, но мы получаем с dex информацию о _impermanentLoss, для компиляции контракта буду просто вводить nftId
        return nftId;
    }
}