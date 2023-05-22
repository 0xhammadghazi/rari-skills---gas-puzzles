// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(
        uint256[] calldata data
    ) external pure returns (uint256[] memory) {
        // 1. Read the array length to iterate over directly from the calldata array instead of memory.
        // 2. Copied the entire calldata array to memory at once instead of copying index by index.
        // 3. Declared the 'temp' variable outside the loop instead of inside the loop.
        // 4. Moved the entire sorting algorithm to the unchecked block as we were performing addition multiple times (i++, j++, and j = i+1).

        uint[] memory _data = data;

        uint256 temp;
        unchecked {
            for (uint256 i = 0; i < data.length; i++) {
                for (uint256 j = i + 1; j < data.length; j++) {
                    if (_data[i] > _data[j]) {
                        temp = _data[i];
                        _data[i] = _data[j];
                        _data[j] = temp;
                    }
                }
            }
        }

        return _data;
    }
}
