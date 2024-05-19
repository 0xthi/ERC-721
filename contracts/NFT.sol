// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    uint256 public totalSupply = 999;
    uint256 public tokenPrice = 10000000000000000;

    constructor(
        address initialOwner
    ) ERC721("MyNFT", "MNT") Ownable(initialOwner) {}

    function safeMint(address to) public payable {
        require(
            msg.value == tokenPrice,
            "Amount sent is less than token price"
        );
        uint256 tokenId = _nextTokenId++;
        require(tokenId < totalSupply, "NFT total supply reached");
        _safeMint(to, tokenId);
    }

    function safeMintMultipleTokens(
        address to,
        uint256 noOfNFT
    ) public payable {
        require(noOfNFT <= 9, "Only 9 NFT can be minted at a time");
        require(
            msg.value == noOfNFT * tokenPrice,
            "Amount sent is less than token price"
        );
        for (uint256 i = 1; i <= noOfNFT; i++) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(to, tokenId);
        }
    }

    function withdrawBalanceTo(address _to) public onlyOwner {
        require(
            address(this).balance < 0,
            "Contract doesn't have enough balance"
        );
       (bool sent, bytes memory data) = _to.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
        }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
