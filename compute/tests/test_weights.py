import pytest
from tuik_calc import weighted_mean, weighted_total, coefficient_of_variation


def test_weighted_mean_hand_calculated():
    assert weighted_mean([10, 20], [1, 3]) == pytest.approx(17.5)


def test_weighted_total():
    assert weighted_total([1, 2, 3], [10, 10, 10]) == pytest.approx(60.0)


def test_equal_weights_equals_plain_mean():
    assert weighted_mean([2, 4, 6], [5, 5, 5]) == pytest.approx(4.0)


@pytest.mark.parametrize("v,w", [([1], [0]), ([1], [-1]), ([1, 2], [1]), ([], []), ([float("nan")], [1])])
def test_invalid_inputs(v, w):
    with pytest.raises(ValueError):
        weighted_mean(v, w)


def test_cv():
    assert coefficient_of_variation(2, 40) == pytest.approx(5.0)
    with pytest.raises(ValueError):
        coefficient_of_variation(1, 0)
