from tuik_calc import check_range, check_required, check_unique, check_sum


def test_range():
    f = check_range([{"x": 5}, {"x": 500}], "x", 0, 100)
    assert [(x.rule, x.row) for x in f] == [("V001", 1)]


def test_required_and_unique():
    rows = [{"id": 1, "a": ""}, {"id": 1, "a": 2}]
    assert [x.row for x in check_required(rows, "a")] == [0]
    assert [x.row for x in check_unique(rows, "id")] == [1]


def test_sum_consistency_with_tolerance():
    rows = [{"a": 1, "b": 2, "t": 3}, {"a": 1, "b": 2, "t": 4}]
    assert [x.row for x in check_sum(rows, ["a", "b"], "t")] == [1]
