// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is ERC721Enumerable, Ownable {
    struct Land {
        string name;
        string description;
        uint256 surface;
    }

    Land[] public lands;
    mapping(uint256 => uint256) public landPrice;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function createLand(string memory _name, string memory _description, uint256 _surface, uint256 _price) external onlyOwner {
        lands.push(Land(_name, _description, _surface));
        uint256 tokenId = lands.length - 1;
        _mint(msg.sender, tokenId);
        landPrice[tokenId] = _price;
    }

    function buyLand(uint256 _tokenId) external payable {
        require(_exists(_tokenId), "Token ID does not exist");
        require(msg.value >= landPrice[_tokenId], "Insufficient payment");

        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
        landPrice[_tokenId] = 0; // Land is no longer for sale
        payable(owner).transfer(msg.value);
    }

    function getLand(uint256 _tokenId) external view returns (Land memory) {
        require(_exists(_tokenId), "Token ID does not exist");
        return lands[_tokenId];
    }
}
