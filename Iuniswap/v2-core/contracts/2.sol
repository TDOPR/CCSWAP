pragma solidity ^0.8.0;

contract a {
    function log_2(int128 x) internal pure returns (int128) {
        unchecked {
            // 代码使用了 solidity 0.8，关闭溢出保护
            require(x > 0);

            int256 msb = 0;
            int256 xc = x;
            if (xc >= 0x10000000000000000) {
                xc >>= 64;
                msb += 64;
            }
            if (xc >= 0x100000000) {
                xc >>= 32;
                msb += 32;
            }
            if (xc >= 0x10000) {
                xc >>= 16;
                msb += 16;
            }
            if (xc >= 0x100) {
                xc >>= 8;
                msb += 8;
            }
            if (xc >= 0x10) {
                xc >>= 4;
                msb += 4;
            }
            if (xc >= 0x4) {
                xc >>= 2;
                msb += 2;
            }
            if (xc >= 0x2) msb += 1; // No need to shift xc anymore
            // 上面的部分，通过二分查找的方式，求出 MSB 的位数

            int256 result = (msb - 64) << 64; // 将 MSB 的位数写入结果的整数部分，这里用到了前面的定点数对数公式
            // 这里是求出 x/2^n, 并且将其整体左位移 127 位，位移后小数部分位数为 127 位
            uint256 ux = uint256(int256(x)) << uint256(127 - msb);
            // 开始迭代，0x8000000000000000 即为 Q64.64 表示的 1/2，迭代的次数为 64 次
            for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
                ux *= ux; // 计算 x^2，计算完成后小数部分位数为 254 位，整数部分为 2 位
                uint256 b = ux >> 255; // 这里的 trick 是判断 ux >= 2，因为整数部分为 2 位，当 ux >= 2 时，其第 1 位必然为 1，第 0 位的值我们不需要关心
                ux >>= 127 + b; // 将 ux 的小数部分恢复为 127 位，并且如果上一步中整数部分第 1 位为1，即 ux >= 2 时， ux = ux/2
                result += bit * int256(b); // 当 ux >= 2 时，将 delta 加到结果中
            }

            return int128(result);
        }
    }
}

log_2(1.5);
