// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

import "./IProxy.sol";

contract ProxyAdmin {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function getProxyAdmin(address proxy) external view returns(address) {
        // We call as staticcall to guarantee that this is a read only call to the admin method
        (bool succcess, bytes memory response) = proxy.staticcall(
            abi.encodeCall(IProxy.admin, ())
        );
        require(succcess, "Call failed.");
        return _decodeAddress(response);
    }

    function getProxyImplementation(address proxy) external view returns(address) {
        // We call as staticcall to guarantee that this is a read only call to the implementation method
        (bool succcess, bytes memory response) = proxy.staticcall(
            abi.encodeCall(IProxy.implementation, ())
        );
        require(succcess, "Call failed.");
        return _decodeAddress(response);
    }

    // As the proxy contract has receive and payable function we need to declare the proxy as payable
    function changeProxyAdmin(address payable proxy, address admin) external onlyOwner {
        IProxy(proxy).changeAdmin(admin);
    }

    function upgrade(address payable proxy, address implementation) external onlyOwner {
        IProxy(proxy).upgradeTo(implementation);
    }

    function _decodeAddress(bytes memory _addr) private pure returns(address) {
        return abi.decode(_addr, (address));
    }
    
}