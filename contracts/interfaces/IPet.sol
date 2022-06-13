// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IPet {
    function _feedPet(uint256 tokenId) external returns(bool);
}