//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404a/ERC404aMetadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WIFU is ERC404Metadata {
    string public baseTokenURI;

    constructor(
        address _owner
    ) ERC404Metadata("WIFU 404", "WIFU", 18, 200000, _owner, 100) {
        balanceOf[_owner] = 200000 * 10 ** 18;
    }

    function setTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    function setNameSymbol(
        string memory _name,
        string memory _symbol
    ) public onlyOwner {
        _setNameSymbol(_name, _symbol);
    }

    /**
     * @dev Overrides the parent implementation in ERC404Metadata.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}