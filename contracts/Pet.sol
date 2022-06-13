// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Pet__OutOfTime();
error Pet__PetStarves();

contract Pet is ERC721URIStorage {
    uint256 public s_tokenId;
    uint256 public s_lastTimestamp;
    uint256 public constant s_time = 5 minutes;

    struct PetItem {
        uint256 tokenId;
        bool isPetFed;
        uint256 lastUptatedAt;
    }

    mapping(uint256 => PetItem) public s_petItems;
    event NFTMinted(uint256 indexed tokenId, uint256 createdAt);

    constructor() ERC721("Pet NFT", "PNFT") {
        s_lastTimestamp = block.timestamp;
    }

    function mint(string memory tokenURI) external returns(uint256) {
        s_tokenId++;

        _safeMint(msg.sender, s_tokenId);
        _setTokenURI(s_tokenId, tokenURI);

        s_petItems[s_tokenId] = PetItem(s_tokenId, false, block.timestamp);
        emit NFTMinted(s_tokenId, block.timestamp);
        return s_tokenId;
    }

    function _feedPet(uint256 tokenId) external virtual returns(bool) {
        PetItem memory pet = s_petItems[tokenId];
        if (pet.lastUptatedAt - s_lastTimestamp > s_time) revert Pet__PetStarves();

        s_petItems[tokenId].lastUptatedAt = block.timestamp;
        s_petItems[tokenId].isPetFed = true;
        s_lastTimestamp = block.timestamp + s_time;

        return true;
    }
}