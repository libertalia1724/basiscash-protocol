// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20, ERC20Burnable} from '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';

import {Operator} from '../access/Operator.sol';

contract Share is ERC20Burnable, Operator {
    /**
     * @notice Constructs the Basis Share ERC-20 contract.
     */
    constructor() ERC20('BAS', 'BAS') {
        // Mints 1 Basis Share to contract creator for initial Uniswap oracle deployment.
        // Will be burned after oracle deployment
        _mint(msg.sender, 1 * 10**18);
    }

    /**
     * @notice Operator mints basis share to a recipient
     * @param recipient The address of recipient
     * @param amount The amount of basis share to mint to
     */
    function mint(address recipient, uint256 amount) external onlyOperator {
        _mint(recipient, amount);
    }

    function burnFrom(address account, uint256 amount) public override onlyOperator {
        super.burnFrom(account, amount);
    }
}
