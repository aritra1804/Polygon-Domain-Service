// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
// We import another help function
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract Domains is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string public tld;
	
	// We'll be storing our NFT images on chain as SVGs
  // string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-10.081 6.032-6.85 3.934-10.081 6.032c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616c-.384-.665-.594-1.418-.608-2.187v-9.31c-.013-.775.185-1.538.572-2.208a4.25 4.25 0 0 1 1.625-1.595l7.884-4.59c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v6.032l6.85-4.065v-6.032c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595L41.456 24.59c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595c-.387.67-.585 1.434-.572 2.208v17.441c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l10.081-5.901 6.85-4.065 10.081-5.901c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v9.311c.013.775-.185 1.538-.572 2.208a4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616c-.385-.665-.594-1.418-.608-2.187v-6.032l-6.85 4.065v6.032c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l14.864-8.655c.657-.394 1.204-.95 1.589-1.616s.594-1.418.609-2.187V55.538c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
  string svgPartOne = '<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 270 270"><defs><style>.cls-1{fill:url(#linear-gradient);}.cls-2{fill:#fff;}</style><linearGradient id="linear-gradient" y1="572" x2="270" y2="842" gradientTransform="translate(0 -572)" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity="0.99"/></linearGradient></defs><path class="cls-1" d="M0,0H270V270H0Z" transform="translate(0 0)"/><path class="cls-2" d="M72.9,42.9a4.33,4.33,0,0,0-4.4,0l-10.1,6-6.8,3.9-10.1,6a4.33,4.33,0,0,1-4.4,0l-8-4.7a4.89,4.89,0,0,1-1.6-1.6,4.28,4.28,0,0,1-.6-2.2V41a4.28,4.28,0,0,1,.6-2.2,4.1,4.1,0,0,1,1.6-1.6L37,32.6a4.33,4.33,0,0,1,4.4,0l7.9,4.6a4.89,4.89,0,0,1,1.6,1.6,4.28,4.28,0,0,1,.6,2.2v6l6.8-4.1v-6a4.28,4.28,0,0,0-.6-2.2,4.1,4.1,0,0,0-1.6-1.6L41.5,24.4a8.51,8.51,0,0,0-2.2-.4,4.56,4.56,0,0,0-2.2.6L22.2,33.3a4.1,4.1,0,0,0-1.6,1.6A3.94,3.94,0,0,0,20,37V54.4a4.28,4.28,0,0,0,.6,2.2,4.1,4.1,0,0,0,1.6,1.6l14.9,8.7a4.33,4.33,0,0,0,4.4,0l10-5.9,6.8-4.1L68.4,51a4.33,4.33,0,0,1,4.4,0l7.9,4.6a4.89,4.89,0,0,1,1.6,1.6,4.28,4.28,0,0,1,.6,2.2v9.3a4.28,4.28,0,0,1-.6,2.2,4.1,4.1,0,0,1-1.6,1.6l-7.9,4.7a4.33,4.33,0,0,1-4.4,0l-7.9-4.6A4.89,4.89,0,0,1,58.9,71a4.28,4.28,0,0,1-.6-2.2v-6l-6.8,4.1v6a4.28,4.28,0,0,0,.6,2.2,4.1,4.1,0,0,0,1.6,1.6l14.9,8.7a4.33,4.33,0,0,0,4.4,0l14.9-8.7a4.1,4.1,0,0,0,1.6-1.6,4.28,4.28,0,0,0,.6-2.2V55.5a4.28,4.28,0,0,0-.6-2.2,4.1,4.1,0,0,0-1.6-1.6l-15-8.8Z" transform="translate(0 0)"/><g id="Layer_2" data-name="Layer 2"><g id="Layer_1-2" data-name="Layer 1-2"><path class="cls-2" d="M209.2,133.6l-10.7-10.1-46.6,44.2c0-.4-.1-.6-.1-.8v-6.4a2,2,0,0,1,.7-1.6c7.3-6.9,14.6-13.9,21.9-20.8l23.4-22.2.7-.7,10.6,10.1,21.4-20.2c0,.5.1.8.1,1.1v11.2a1.61,1.61,0,0,1-.6,1.3c-1.7,1.7-3.5,3.3-5.4,5.2v-4.6l-.2-.1Z" transform="translate(0 0)"/><path class="cls-2" d="M187.9,139.3l10.7,10.1,46.5-44.2a1.09,1.09,0,0,1,.1.5v7a2.38,2.38,0,0,1-.6,1.1c-4.4,4.3-8.8,8.3-13.1,12.5l-24.8,23.6-7.7,7.3c-.2.2-.4.3-.5.4l-10.6-10.1-21.3,20.2c0-.4-.1-.7-.1-.9V155.2a1.69,1.69,0,0,1,.3-1c1.7-1.7,3.5-3.4,5.3-5.1.1-.1.2-.1.3-.2v4.5l.2.1Z" transform="translate(0 0)"/><path class="cls-2" d="M172.5,119.3v19a2,2,0,0,1-.7,1.6c-1.5,1.4-3,2.8-4.5,4.3-.2.2-.4.3-.7.6V105.1l21,19.9-4.4,4.1-10.4-9.9Z" transform="translate(0 0)"/><path class="cls-2" d="M224.6,153.8V134.5a2.11,2.11,0,0,1,.5-1.3c1.6-1.6,3.2-3.1,4.9-4.7.2-.1.4-.3.6-.4v39.7l-21-19.9,4-3.8c.5-.4.7,0,1,.2l8.8,8.3A13.47,13.47,0,0,0,224.6,153.8Z" transform="translate(0 0)"/></g></g></svg>';
  string svgPartTwo = '</text></svg>';

  mapping(string => address) public domains;
  mapping(string => string) public records;

  constructor(string memory _tld) payable ERC721("Alfi Name Service", "ANS") {
    tld = _tld;
    console.log("%s name service deployed", _tld);
  }

  function register(string calldata name) public payable {
    require(domains[name] == address(0));

    uint256 _price = this.price(name);
    require(msg.value >= _price, "Not enough Matic paid");
		
		// Combine the name passed into the function  with the TLD
    string memory _name = string(abi.encodePacked(name, ".", tld));
		// Create the SVG (image) for the NFT with the name
    string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
    uint256 newRecordId = _tokenIds.current();
  	uint256 length = StringUtils.strlen(name);
		string memory strLen = Strings.toString(length);

    console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

		// Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            _name,
            '", "description": "A domain on the Alfi Name service", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '","length":"',
            strLen,
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

		console.log("\n--------------------------------------------------------");
	  console.log("Final tokenURI", finalTokenUri);
	  console.log("--------------------------------------------------------\n");

    _safeMint(msg.sender, newRecordId);
    _setTokenURI(newRecordId, finalTokenUri);
    domains[name] = msg.sender;

    _tokenIds.increment();
  }
	
	// We still need the price, getAddress, setRecord and getRecord functions, they just don't change

		
		// This function will give us the price of a domain based on length
    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
          return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
        } else if (len == 4) {
	        return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
        } else {
	        return 1 * 10**17;
        }
    }

   
		// Other functions unchanged

    function getAddress(string calldata name) public view returns (address) {
				// Check that the owner is the transaction sender
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
				// Check that the owner is the transaction sender
        require(domains[name] == msg.sender);
        records[name] = record;
    }

    function getRecord(string calldata name) public view returns(string memory) {
        return records[name];
    }
}