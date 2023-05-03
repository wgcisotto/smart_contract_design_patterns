// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

contract CarV1 {

    uint public speed;

    function increase() external {
        speed++;
    }

}