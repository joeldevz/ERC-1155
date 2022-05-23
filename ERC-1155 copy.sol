// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;
import "@openzeppelin/contracts@4.5.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

contract TokenUmibu is ERC1155, Ownable {
    //uint256 private ids;
    struct NFTs {
        string uri;
        uint256 number;
        address owner;
    }
    mapping(uint256 => NFTs) private DiccionartNFTs;
    mapping(uint256 => uint256) private security;
    string domain = "https://data.umibu.io/token/1155/{id}";
    using Counters for Counters.Counter;
    string public name = "Umibu";
    Counters.Counter private ids;

    //bytes  data public nameProtocol = "@umibu";
    constructor() ERC1155(domain) {}

    function CheckId(uint256 _id) public view returns (bool) {
        if (
            DiccionartNFTs[_id].number == 0 ||
            DiccionartNFTs[_id].number > block.number
        ) {
            return true;
        }
        return false;
    }

    function mint(
        string memory _id,
        uint256 _amount,
        string memory _uri
    ) public {
        require(CheckId(_id), "ya existe, intentalo de nuevo");
        _mint(msg.sender, _id, _amount, "");
        DiccionartNFTs[_id] = NFTs(_uri, block.number, msg.sender);
    }

    modifier securityFrontRunning(uint256 nftID) {
        require(
            security[nftID] == 0 || security[nftID] < block.number,
            "Error security"
        );
        security[nftID] = block.number;
        _;
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return (string(abi.encodePacked(DiccionartNFTs[_id].uri)));
    }
}
