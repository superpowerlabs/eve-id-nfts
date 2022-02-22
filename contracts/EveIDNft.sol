// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Author: Francesco Sullo <francesco@superpower.io>
// Superpower Labs / Syn City
// Cryptography forked from Everdragons2(.com)'s code

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//import "hardhat/console.sol";

contract EveIDNft is ERC721, Ownable {
  using Address for address;
  using ECDSA for bytes32;

  event ValidatorSet(address validator);
  event OperatorSet(address operator);
  event OperatorRevoked(address operator);
  event BaseURIUpdated();
  event BaseURIFrozen();

  uint256 public nextTokenId = 1;
  uint256 public maxTokenId;

  string private _baseTokenURI;
  bool public tokenURIHasBeenFrozen;

  address public validator;
  mapping(bytes32 => address) public usedCodes;
  mapping(address => bool) public operators;

  constructor(
    address validator_,
    string memory name,
    string memory symbol,
    string memory baseTokenURI
  ) ERC721(name, symbol) {
    setValidator(validator_);
    _baseTokenURI = baseTokenURI;
  }

  function setValidator(address validator_) public onlyOwner {
    require(validator_ != address(0), "validator cannot be 0x0");
    validator = validator_;
    emit ValidatorSet(validator);
  }

  function setOperator(address _operator) public onlyOwner {
    require(_operator != address(0), "operator cannot be 0x0");
    operators[_operator] = true;
    emit OperatorSet(_operator);
  }

  function revokeOperator(address operator_) external onlyOwner {
    delete operators[operator_];
    emit OperatorRevoked(operator_);
  }

  function startDistribution(uint256 maxTokenId_) external onlyOwner {
    require(maxTokenId_ > 0, "max tokenId cannot be zero");
    maxTokenId = maxTokenId_;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function updateBaseTokenURI(string memory uri) external onlyOwner {
    require(!tokenURIHasBeenFrozen, "token uri has been frozen");
    _baseTokenURI = uri;
    emit BaseURIUpdated();
  }

  function freezeBaseTokenURI() external onlyOwner {
    tokenURIHasBeenFrozen = true;
    emit BaseURIFrozen();
  }

  function contractURI() external view returns (string memory) {
    return string(abi.encodePacked(_baseTokenURI, "0"));
  }

  function claimFreeToken(
    bytes32 authCode,
    uint256 typeIndex,
    bytes memory signature
  ) external {
    _mintToken(_msgSender(), authCode, typeIndex, signature);
  }

  function giveawayToken(
    address to,
    bytes32 authCode,
    bytes memory signature
  ) external {
    require(_msgSender() != address(0) && operators[_msgSender()], "forbidden");
    _mintToken(to, authCode, 4, signature);
  }

  function _mintToken(
    address to,
    bytes32 authCode,
    uint256 typeIndex,
    bytes memory signature
  ) internal {
    require(to != address(0), "invalid sender");
    require(maxTokenId > 0, "distribution not started, yet");
    require(nextTokenId <= maxTokenId, "distribution ended");
    require(usedCodes[authCode] == address(0), "authCode already used");
    // TODO check if next one is necessary
    //    require(balanceOf(to) == 0, "one pass per wallet");
    require(isSignedByValidator(encodeForSignature(to, authCode, typeIndex), signature), "invalid signature");
    usedCodes[authCode] = to;
    _safeMint(to, nextTokenId++);
  }

  // the following 2 functions are called internally by _mintToken
  // and externally by the web3 app

  function isSignedByValidator(bytes32 _hash, bytes memory _signature) public view returns (bool) {
    return validator != address(0) && validator == _hash.recover(_signature);
  }

  function encodeForSignature(
    address to,
    bytes32 authCode,
    uint256 typeIndex
  ) public view returns (bytes32) {
    return
      keccak256(
        abi.encodePacked(
          "\x19\x01", // EIP-191
          getChainId(),
          to,
          authCode,
          typeIndex
        )
      );
  }

  function getChainId() public view returns (uint256) {
    uint256 id;
    assembly {
      id := chainid()
    }
    return id;
  }
}
