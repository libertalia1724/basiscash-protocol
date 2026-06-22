// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LegacyOperator} from '../legacy/LegacyOperator.sol';

contract MockLegacyOperator is LegacyOperator {
    bool public operatorCalled;

    function onlyOperatorFunction() external onlyOperator {
        operatorCalled = true;
    }
}