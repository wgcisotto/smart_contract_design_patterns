// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;

import "./IProxy.sol";
import "./libs/StorageSlot.sol";

contract Proxy is IProxy {
    // All functions / variables should be private, forward all calls to fallback

    // The following two declarations is used to control the slot of memory that
    // is used to store both admin and implementation addresses
    // this is used to avoid storage collision 
    // -1 for unknown preimage - is a precautionary measure to prevent hash collision attacks.
    // A hash collision attack is when two different inputs generate the same hash output. 
    // In the context of contract storage, this can be exploited by an attacker to overwrite 
    // the data in the storage. By subtracting -1 from the keccak256 hash output, 
    // a different pre-image is generated, which helps to ensure that 
    // the probability of collision is significantly reduced.
    // 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
    // Describe better why -1 here
    // 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103
    bytes32 private constant ADMIN_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);

    constructor() {
        _setAdmin(msg.sender);
    }
    
    /**
     * @dev Modifier used internally that will delegate the call to the implementation 
     * unless the sender is the admin.
     *
     * This modifier presents function selector collision
     *
     */
    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    function changeAdmin(address _addr) external ifAdmin {
        _setAdmin(_addr);
    }

    function upgradeTo(address _addr) external ifAdmin {
        _setImplementation(_addr);
    }

    function admin() external ifAdmin returns (address) {
        return _getAdmin();
    }

    function implementation() external ifAdmin returns (address) {
        return _getImplementation();
    }
    
    function _setImplementation(address addr) private {
        require(addr.code.length > 0, "implementation is not contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = addr;
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setAdmin(address _addr) private {
        require(_addr != address(0), "admin equals to zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _addr;
    }

    function _getAdmin() private view returns(address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _delegate(address _implementation) private {
        //(bool success, bytes memory response) = impl.delegatecall(msg.data);
        //require(success, "Delegate call failed");
        // As the _delegate is used by the fallback and receive function both has no return argment
        // thus, we need assembly to return the data
        // ref: Peace of Code above from openzeppelin
        // Inside the assembly we are copying the call data and we manually call delegatecall
        // then we manually copy and check the response
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly block,
            // because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to mem at position t
            // calldatasize() - size of call data in bytes
            // Copy the the calldata data into memory 
            calldatacopy(0, 0, calldatasize()) 
            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            // delegatecall(g, a, in, insize, out, outsize) -
            // - call contract at address a
            // - with input mem[in…(in+insize))
            // - providing g gas
            // - and output area mem[out…(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            // fowards all the gas with gas()
            let result := delegatecall(
                gas(), _implementation, 0, calldatasize(), 0, 0
            )
            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f to mem at position t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())
            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            } default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    // Fallback: function is used to forward all the requests to the implementation contract
    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}
