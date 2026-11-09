import pytest
from tuik_calc import percent_change, chain_index


def test_percent_change_basic():
    assert percent_change(110, 100) == pytest.approx(10.0)


def test_percent_change_zero_previous():
    with pytest.raises(ValueError):
        percent_change(1, 0)


def test_chain_index():
    assert chain_index(100.0, [10.0, -10.0]) == pytest.approx([110.0, 99.0])


def test_chain_index_empty():
    assert chain_index(100.0, []) == []
