import pytest
from tuik_calc import is_small_cell, is_dominated, suppress_row, secondary_suppress, SUPPRESSED


def test_small_cell_threshold_is_parameter():
    assert is_small_cell(2, 3) and not is_small_cell(3, 3)
    with pytest.raises(ValueError):
        is_small_cell(1, 0)


def test_dominance():
    assert is_dominated([90, 5, 5], top_n=1, max_share=0.8)
    assert not is_dominated([34, 33, 33], top_n=1, max_share=0.8)
    assert not is_dominated([0, 0], top_n=1, max_share=0.8)


def test_suppress_row_marks_gizli_not_zero():
    out = suppress_row([10.0, 20.0, 30.0], [5, 2, 9], min_count=3)
    assert out == [10.0, SUPPRESSED, 30.0]
    assert 0 not in out


def test_secondary_suppression_prevents_back_calculation():
    out = secondary_suppress([10.0, SUPPRESSED, 30.0], total=60.0)
    assert out.count(SUPPRESSED) == 2


def test_secondary_suppression_noop_when_total_unknown():
    row = [10.0, SUPPRESSED, 30.0]
    assert secondary_suppress(row, None) == row
