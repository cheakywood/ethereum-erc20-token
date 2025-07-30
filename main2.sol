// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Private state variables to hold the name and symbol
    string private _tokenName;
    string private _tokenSymbol;

    // Flag to ensure initialization only happens once
    bool private _isInitialized;

    constructor() ERC20("", "") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function createToken(string memory name_, string memory symbol_) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!_isInitialized, "Token has already been initialized");
        _tokenName = name_;
        _tokenSymbol = symbol_;
        _isInitialized = true;
    }

    function name() public view override returns (string memory) {
        return _tokenName;
    }

    function symbol() public view override returns (string memory) {
        return _tokenSymbol;
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}
