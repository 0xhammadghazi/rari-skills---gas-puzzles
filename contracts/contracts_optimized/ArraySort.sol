// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(
        uint256[] calldata data
    ) external pure returns (uint256[] memory) {
        // uint256 dataLen = data.length;

        // Create 'working' copy
        uint[] memory _data = data;
        // for (uint256 k = 0; k < _data.length; k++) {
        //     _data[k] = data[k];
        // }

        uint256 temp;

        for (uint256 i = 0; i < data.length; ) {
            for (uint256 j = i + 1; j < data.length; ) {
                if (_data[i] > _data[j]) {
                    temp = _data[i];
                    _data[i] = _data[j];
                    _data[j] = temp;
                }

                unchecked {
                    ++j;
                }
            }

            unchecked {
                ++i;
            }
        }
        return _data;
    }
}
