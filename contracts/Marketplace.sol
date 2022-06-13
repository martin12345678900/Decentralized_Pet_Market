// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Food.sol";

import "./interfaces/IPet.sol";

error Marketplace__NotEnoughSend();
error Marketplace__NotEnoughBalance();
error Marketplace__NotEnoughETHProvided();
error Marketplace__TransferFailed();
error Marketplace__LowBalance();

contract Marketplace is Food {
    using SafeMath for uint256;
    uint256 public constant i_foodToETHPercent = 1;
    uint256 public constant i_tokensToFeedPet = 5;
    mapping(address => uint256) public s_users;

    IPet public s_pet;

    constructor(address pet) {
        s_pet = IPet(pet);
    }

    function mintFood(uint256 amount) external {
        _mint(address(this), amount);
    }

    function purchaseFood(uint256 amount) external payable {
        uint256 foodPrice = amount * (i_foodToETHPercent / 100);
        // checks if the marketplace has enough minted food tokens
        if (amount > balanceOf(address(this))) revert Marketplace__NotEnoughBalance();
        // checks if the user pays enough eth to buy requested amount
        if (foodPrice > msg.value) revert Marketplace__NotEnoughETHProvided();

        // 1 -> 0.01 eth
        // 2 -> 0.02 eth
        // 10 -> 0.1 eth
        // 50 -> 0.5 eth
        // 100 -> 1 eth

        // increase the bought food tokens
        s_users[msg.sender] += amount;
        // transfer the food tokens from the marketplace to the user
        (bool success) = transferFrom(address(this), msg.sender, amount);
        if (!success) revert Marketplace__TransferFailed();
    }

    function feedPet(uint256 tokenId) external {
        // checks if the user has enough purchase food to feed the pet
        if (balanceOf(msg.sender) < i_tokensToFeedPet) revert Marketplace__LowBalance();
        // trying to feed it
        (bool success) = s_pet._feedPet(tokenId);

        // if successful we burn the tokens spent to feed the pet
        if (success) _burn(msg.sender, i_tokensToFeedPet);
    }
}