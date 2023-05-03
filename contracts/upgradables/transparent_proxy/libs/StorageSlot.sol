// SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.0 <0.9.0;
// Used to storage data in solidity in any storage slot
// Smart contract's storage consists of 2^256 slots, 
// where each slot can contain values of size up to 32 bytes. 
// The contract storage is a key-value store, where 256 bits keys map to 256 bits values.
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(bytes32 slot) internal pure returns(AddressSlot storage r){
        // Gets the value of the slot passed as argument and set to the r.slot
        assembly {
            r.slot := slot
        }
    }
}