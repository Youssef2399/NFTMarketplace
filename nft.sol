// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LandNFT is ERC721URIStorage, Ownable {
    uint256 private tokenIdCounter = 0;

    constructor() ERC721("LandNFT", "LAND") {}

    function mintLandNFT(string memory _name, string memory _description, uint256 _surface, string memory _tokenURI) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;

        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        // Store additional metadata
        landMetadata[tokenId] = Land(_name, _description, _surface);

        emit LandNFTMinted(tokenId, _name, _description, _surface);
    }

    struct Land {
        string name;
        string description;
        uint256 surface;
    }

    mapping(uint256 => Land) public landMetadata;

    event LandNFTMinted(uint256 indexed tokenId, string name, string description, uint256 surface);
}
