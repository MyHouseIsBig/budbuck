// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC1155/extensions/ERC1155Supply.sol";

/// @custom:security-contact info@mydrugs.center
contract MyDrugsERC1155Token is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {

    mapping(uint256 => uint256) private _coinBalances;
    mapping(uint256 => address) private _nftCreators;

    uint256 public constant BUD_BUCK_ID = 1;
    uint256 public constant NFT_BASE_ID = 1000;

    constructor(address initialOwner)
        ERC1155("https://api.mydrugs.center/token/{id}.json")
        Ownable(initialOwner)
    {
        _mint(msg.sender, BUD_BUCK_ID, 1000000000, ""); // Mint initial supply of BudBucks
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mintNFT(address account, uint256 id, uint256 amount) public onlyOwner {
        require(id >= NFT_BASE_ID, "Invalid NFT ID");
        _mint(account, id, amount, "");
        _nftCreators[id] = account;
    }

    function coinBalanceOf(address account) public view returns (uint256) {
        return balanceOf(account, BUD_BUCK_ID);
    }

    function nftCreatorOf(uint256 id) public view returns (address) {
        require(id >= NFT_BASE_ID, "Invalid NFT ID");
        return _nftCreators[id];
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
