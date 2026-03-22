from buggy_math import add

def test_add_logic():
    # add(1, 2)가 3을 반환해야 성공
    result = add(1, 2)
    assert result == 3, f"에러: 1 + 2 = 3이어야 하지만 {result}가 반환됨"
