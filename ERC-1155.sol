// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.4;
import "@openzeppelin/contracts@4.5.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

contract TokenUmibu is ERC1155, Ownable {
    //uint256 private ids;
    mapping(uint256 => string) private hashIpfs;
    mapping(uint256 => uint256) private security;
    string domain = "https://data.umibu.io/token/1155/{id}";
    using Counters for Counters.Counter;
    string public name = "Umibu";

    function getName() public view returns (string memory) {
        return name;
    }

    Counters.Counter private ids;

    //bytes  data public nameProtocol = "@umibu";
    constructor() ERC1155(domain) {}

    function GetId() public view returns (uint256) {
        return ids.current();
    }

    function NextId() public view returns (uint256) {
        uint256 temp = GetId();
        temp = temp + 1;
        return temp;
    }

    function mint(uint256 _amount, string memory _uri) public {
        uint256 _idsTem = NextId();
        require(_idsTem >= GetId(), "ya existe, intentalo de nuevo");
        ids.increment();
        _mint(msg.sender, GetId(), _amount, "");
        hashIpfs[_idsTem] = _uri;
    }

    modifier securityFrontRunning(uint256 nftID) {
        require(
            security[nftID] == 0 || security[nftID] < block.number,
            "Error security"
        );
        security[nftID] = block.number;
        _;
    }
    function addAmount(uint256 _id, uint256 _amount) onlyOwner() public{
        require(_id <= GetId(), "ya existe, intentalo de nuevo");
        _mint(msg.sender, _id, _amount, "");
    }
    function uri(uint256 tokenId) public view override returns (string memory) {
        return (string(abi.encodePacked(hashIpfs[tokenId])));
    }
}
