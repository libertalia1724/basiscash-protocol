// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Operator} from '../access/Operator.sol';
import {Curve} from './Curve.sol';

contract LinearThreshold is Operator, Curve {

    /* ========== CONSTRUCTOR ========== */

    constructor(
        uint256 _minSupply,
        uint256 _maxSupply,
        uint256 _minCeiling,
        uint256 _maxCeiling
    ) {
        minSupply = _minSupply;
        maxSupply = _maxSupply;
        minCeiling = _minCeiling;
        maxCeiling = _maxCeiling;
    }

    /* ========== GOVERNANCE ========== */

    function setMinSupply(uint256 _newMinSupply) public override onlyOperator {
        super.setMinSupply(_newMinSupply);
    }

    function setMaxSupply(uint256 _newMaxSupply) public override onlyOperator {
        super.setMaxSupply(_newMaxSupply);
    }

    function setMinCeiling(uint256 _newMinCeiling)
        public
        override
        onlyOperator
    {
        super.setMinCeiling(_newMinCeiling);
    }

    function setMaxCeiling(uint256 _newMaxCeiling)
        public
        override
        onlyOperator
    {
        super.setMaxCeiling(_newMaxCeiling);
    }

    /* ========== VIEW FUNCTIONS ========== */

    function calcCeiling(uint256 _supply)
        public
        view
        override
        returns (uint256)
    {
        if (_supply <= minSupply) {
            return maxCeiling;
        }
        if (_supply >= maxSupply) {
            return minCeiling;
        }

        uint256 slope = (maxCeiling - minCeiling) * 1e18 / (maxSupply - minSupply);
        uint256 ceiling = maxCeiling - (slope * (_supply - minSupply) / 1e18);

        return ceiling;
    }
}
