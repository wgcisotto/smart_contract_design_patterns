// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

interface IProxy {

    function changeAdmin(address _admin) external;

    function upgradeTo(address _implementation) external;

    function admin() external returns(address);

    function implementation() external returns(address);
    
}