// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract A {
    bytes4 public constant GET_NUMBER = bytes4(keccak256("getNumber()"));

    uint256 public z;

    // 0xf2c9ecd8
    function getNumber() external pure returns (uint256 c) {
        c = 7;
    }

    // 0x3fb5c1cb
    function setNumber(uint256 _z) external {
        z = _z;
    }

    function getBytes(uint256 a) external pure returns (bytes memory) {
        bytes memory data = new bytes(a);

        uint256 i;
        for (; i < a; ) {
            data[i];
            unchecked {
                ++i;
            }
        }
        return data;
    }
}
