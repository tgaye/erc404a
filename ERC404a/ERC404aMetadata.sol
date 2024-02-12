//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404a.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC404aMetadata is ERC404a {
    using Strings for uint256;

    /**
     * @dev Since ERC404 dynamically burns and mints tokenIds, any one piece of 
     * metadata is not necessarily tied to one tokenId across different points 
     * in time. Static hosting services, such as IPFS, cannot dynamically update
     * to accomodate these requirements. Hence, metadataIds maps a tokenId
     * to a number between 0 and totalNativeSupply, which correlates to the metadata 
     * index of that tokenId.
     * It should be noted that due to the re-implementation of the _mint function,
     * any transfers occuring before the totalNativeSupply is reached will generate new
     * metadata for that NFT.
     */
    mapping(uint256 => uint256) public metadataIds;

    /**
     * @dev pendingIds is a linked list of tokenIds. Its implementation is 
     * essentially a LIFO queue. It accounts for transfers between a 
     * whitelisted and non-whitelisted user where NFTs are burned but 
     * not minted, or vice-versa.
     */
    mapping(uint256 => uint256) public pendingIds;

    /**
     * @dev Implemented in the _mint function.
     */
    uint256 public totalNativeSupply;

    // Constructor
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalNativeSupply,
        address _owner,
         /// @dev Number of tokens required to recieve NFT
        uint256 _tokensRequiredForMint
    ) ERC404a(_name, _symbol, _decimals, _totalNativeSupply, _owner, _tokensRequiredForMint) {
        totalNativeSupply = _totalNativeSupply;
    }

    /**
     * @dev Implementation from ERC721.
     * Empty by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev Implementation from ERC721, with the only changes being 
     * 1. tokenId is instead metadataIds[tokenId], where 0 < tokenId < totalNativeSupply
     * 2. _requireOwned(tokenId); is not used, since there is no implementation
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(tokenId > 0 && tokenId <= totalSupply, "ERC404a: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        // Subtract 1 from tokenId to match the desired filename in the URI
        uint256 metadataIndex = tokenId - 1;
        return bytes(baseURI).length > 0 
            ? string(abi.encodePacked(baseURI, Strings.toString(metadataIndex), ".json")) 
            : "";
    }

    /**
     * @dev Re-implementation from ERC404.sol
     */
    function _mint(address to) internal virtual override {
        if (to == address(0)) {
            revert InvalidRecipient();
        }

        unchecked {
            minted++;
        }

        uint256 id = minted;

        if (_ownerOf[id] != address(0)) {
            revert AlreadyExists();
        }

        _ownerOf[id] = to;
        _owned[to].push(id);
        _ownedIndex[id] = _owned[to].length - 1;

        /**
         * @dev The logic is as follows:
         * 1. if minted > totalNativeSupply, the tokenId is added to the queue
         * 2. otherwise, the metadataId is the tokenId
         * (this means that mints under the totalNativeSupply generate new metadata)
         */
        if (id > totalNativeSupply) {
            uint256 firstId = pendingIds[0];
            metadataIds[id] = firstId;
            pendingIds[0] = pendingIds[firstId];
        } else {
            metadataIds[id] = id;
        }

        emit Transfer(address(0), to, id);
    }

    /**
     * @dev Re-implementation from ERC404.sol
     */
    function _burn(address from) internal virtual override {
        if (from == address(0)) {
            revert InvalidSender();
        }

        uint256 id = _owned[from][_owned[from].length - 1];
        _owned[from].pop();
        delete _ownedIndex[id];
        delete _ownerOf[id];
        delete getApproved[id];

        /**
         * @dev Tokens are prepended to the head of the linked list.
         * If the recipient of the transfer is not whitelisted,
         * these values will removed during the _mint function. 
         */
        uint256 metadataId = metadataIds[id];
        pendingIds[metadataId] = pendingIds[0];
        pendingIds[0] = metadataId;

        emit Transfer(from, address(0), id);
    }

}