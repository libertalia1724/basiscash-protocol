// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20, ERC20Burnable} from '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';

import {Operator} from '../access/Operator.sol';

contract ShareV2 is ERC20Burnable, Operator {
    /**
     * @notice Constructs the Basis Share V2 ERC-20 contract.
     */
    constructor() ERC20('BASv2', 'BASv2') {}

    /**
     * @notice Operator mints basis share v2 to a recipient
     * @param recipient The address of recipient
     * @param amount The amount of basis share v2 to mint to
     */
    function mint(address recipient, uint256 amount) external onlyOperator {
        _mint(recipient, amount);
    }

    function burnFrom(address account, uint256 amount) public override onlyOperator {
        super.burnFrom(account, amount);
    }
}
