// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/math/Math.sol';

import '../access/Operator.sol';

contract Epoch is Operator {
    uint256 private period;
    uint256 private startTime;
    uint256 private lastExecutedAt;

    /* ========== CONSTRUCTOR ========== */

    constructor(
        uint256 _period,
        uint256 _startTime,
        uint256 _startEpoch
    ) {
        require(_startTime > block.timestamp, 'Epoch: invalid start time');
        period = _period;
        startTime = _startTime;
        lastExecutedAt = startTime + _startEpoch * period;
    }

    /* ========== Modifier ========== */

    modifier checkStartTime {
        require(block.timestamp >= startTime, 'Epoch: not started yet');

        _;
    }

    modifier checkEpoch {
        require(block.timestamp > startTime, 'Epoch: not started yet');
        require(callable(), 'Epoch: not allowed');

        _;

        lastExecutedAt = block.timestamp;
    }

    /* ========== VIEW FUNCTIONS ========== */

    function callable() public view returns (bool) {
        return getCurrentEpoch() >= getNextEpoch();
    }

    // epoch
    function getLastEpoch() public view returns (uint256) {
        return (lastExecutedAt - startTime) / period;
    }

    function getCurrentEpoch() public view returns (uint256) {
        return (Math.max(startTime, block.timestamp) - startTime) / period;
    }

    function getNextEpoch() public view returns (uint256) {
        if (startTime == lastExecutedAt) {
            return getLastEpoch();
        }
        return getLastEpoch() + 1;
    }

    function nextEpochPoint() public view returns (uint256) {
        return startTime + getNextEpoch() * period;
    }

    // params
    function getPeriod() public view returns (uint256) {
        return period;
    }

    function getStartTime() public view returns (uint256) {
        return startTime;
    }

    /* ========== GOVERNANCE ========== */

    function setPeriod(uint256 _period) external onlyOperator {
        period = _period;
    }
}
