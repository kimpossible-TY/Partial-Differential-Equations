from buggy_math import add

def test_add_logic():
    # This should pass if add(1, 2) returns 3
    assert add(1, 2) == 3, f"Expected 3, but got {add(1, 2)}"
