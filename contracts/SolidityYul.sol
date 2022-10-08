// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract SolidityYul {
    uint256 x;

    uint128 k = 12;
    uint128 l = 7;

    uint256[] private arr = [6, 8, 9];

    mapping(uint256 => uint256) public trackNum;

    function add(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := add(a, b)
        }
    }

    function getString() external view returns (string memory c) {
        bytes32 _string;
        assembly {
            _string := "Hello World"
        }

        c = string(abi.encode(_string));
        console.log("The res is", c);
    }

    function setNumber(uint256 newNumber) external {
        assembly {
            let slot := x.slot
            sstore(slot, newNumber)
        }
    }

    function getNumber() external view returns (uint256 slot, uint256 num) {
        assembly {
            slot := x.slot
            num := sload(slot)
        }
    }

    function getUint128Numbers()
        external
        view
        returns (uint256 first, uint256 second)
    {
        // 0x000000000000000000000000000000070000000000000000000000000000000c
        // 0x000000000000000000000000000000000000000000000000000000000000000c
        assembly {
            let slot := k.slot
            let nums := sload(slot)
            first := and(
                nums,
                0x000000000000000000000000000000000000000000000000000000000000000c
            )

            second := shr(mul(l.offset, 8), nums)
        }
    }

    function setK(uint256 newNumber) external {
        // 0x0000000000000000000000000000000000000000000000000000000000000003 --newNumber

        assembly {
            let value := sload(k.slot)
            // 0x000000000000000000000000000000070000000000000000000000000000000c -- value
            // 0x0000000000000000000000000000000700000000000000000000000000000000

            let newVal := and(
                value,
                0x0000000000000000000000000000000700000000000000000000000000000000
            )

            let newNum := or(newNumber, newVal)

            sstore(k.slot, newNum)
        }
        console.log("The new value for k is", k);
        console.log("The new value for l is", l);
    }

    function getNumbers() external pure returns (uint256, uint256) {
        assembly {
            mstore(0x00, 2)
            mstore(0x20, 7)

            return(0x00, 0x40)
        }
    }

    function setMapNumber(uint256 key, uint256 num) external {
        assembly {
            let slot := trackNum.slot
            let m := mload(0x40)
            mstore(m, key)
            mstore(add(m, 0x20), slot)
            let location := keccak256(m, 0x40)
            sstore(location, num)
        }
    }

    function readMap(uint256 key) external view returns (uint256 c) {
        assembly {
            let slot := trackNum.slot
            let ptr := mload(0x40)
            mstore(ptr, key)
            mstore(add(ptr, 32), slot)

            let location := keccak256(ptr, 0x40)
            c := sload(location)
        }
    }

    function readNumber(address addr) external view returns (uint256) {
        assembly {
            mstore(0x00, 0xf2c9ecd8)
            // 0x00000000000000000000000000000000000000000000000000000000f2c9ecd8
            let res := staticcall(gas(), addr, 28, 32, 0x00, 0x20)

            if iszero(res) {
                revert(0, 0)
            }

            return(0x00, 0x20)
        }
    }

    function writeNumber(address addr, uint256 num) external {
        assembly {
            mstore(0x00, 0x3fb5c1cb)
            mstore(0x20, num)
            // 0x00000000000000000000000000000000000000000000000000000000f2c9ecd8
            // callvalue() will be zero
            let res := call(
                gas(),
                addr,
                callvalue(),
                28,
                add(28, 32),
                0x00,
                0x00
            )

            if iszero(res) {
                revert(0, 0)
            }
        }
    }

    function readDynamicDataLength(address addr, uint256 n)
        external
        view
        returns (bytes memory)
    {
        assembly {
            mstore(0x00, 0x57bc2ef3)
            mstore(0x20, n)

            let res := staticcall(gas(), addr, 28, add(28, 32), 0x00, 0x00)

            if iszero(res) {
                revert(0, 0)
            }

            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }

    function readFromArray(uint256 index) external view returns (uint256 c) {
        assembly {
            let slot := arr.slot
            let ptr := mload(0x40)
            mstore(ptr, slot)

            let location := keccak256(ptr, 0x20)

            c := sload(add(location, index))
        }
    }
}
