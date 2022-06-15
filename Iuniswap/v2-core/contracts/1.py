def log2(x, n):
    assert 1 <= x < 2

    result = 0
    for i in range(0, n):
        if x >= 2:
            result += 1 / (2 ** i)   # 使用公式2
            x /= 2                   # 使用公式2
        x *= x                       # 使用公式1
    return result