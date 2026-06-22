// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Operator} from '../access/Operator.sol';

contract MockOperator is Operator {
    bool public operatorCalled;

    function onlyOperatorFunction() external onlyOperator {
        operatorCalled = true;
    }
}