"""İstatistiki ifşa kontrolü: küçük hücre, baskınlık ve ikincil bastırma (basit, açıklanabilir).

Eşikler KURUM KARARIDIR: parametre olarak verilir, burada varsayılan değer yoktur.
"""
from __future__ import annotations

from typing import Sequence

SUPPRESSED = "gizli"


def is_small_cell(count: int, min_count: int) -> bool:
    """Birim sayısı eşiğin altındaysa True.

    >>> is_small_cell(2, 3)
    True
    """
    if min_count < 1:
        raise ValueError("min_count en az 1 olmalı")
    return count < min_count


def is_dominated(unit_values: Sequence[float], top_n: int, max_share: float) -> bool:
    """En büyük `top_n` birim hücre toplamının `max_share` (0-1) oranından fazlasını oluşturuyorsa True.

    >>> is_dominated([90, 5, 5], top_n=1, max_share=0.8)
    True
    """
    if not 0 < max_share <= 1 or top_n < 1:
        raise ValueError("geçersiz parametre")
    total = sum(unit_values)
    if total <= 0:
        return False
    return sum(sorted(unit_values, reverse=True)[:top_n]) / total > max_share


def suppress_row(values: list[float | None], counts: list[int], min_count: int) -> list[float | str | None]:
    """Birim sayısı eşiğin altındaki hücreleri `gizli` yapar (birincil bastırma).

    >>> suppress_row([10.0, 20.0, 30.0], [5, 2, 9], min_count=3)
    [10.0, 'gizli', 30.0]
    """
    if len(values) != len(counts):
        raise ValueError("values ve counts aynı uzunlukta olmalı")
    return [SUPPRESSED if is_small_cell(c, min_count) else v for v, c in zip(values, counts)]


def secondary_suppress(row: list[float | str | None], total: float | None) -> list[float | str | None]:
    """Toplam açıkken tek bir hücre bastırıldıysa o hücre toplamdan geri hesaplanabilir;
    bu durumda en küçük görünür hücre de bastırılır.

    >>> secondary_suppress([10.0, 'gizli', 30.0], total=60.0)
    ['gizli', 'gizli', 30.0]
    """
    if total is None:
        return row
    hidden = [i for i, v in enumerate(row) if v == SUPPRESSED]
    if len(hidden) != 1:
        return row
    visible = [(i, v) for i, v in enumerate(row) if isinstance(v, (int, float))]
    if not visible:
        return row
    i_min = min(visible, key=lambda t: t[1])[0]
    out = list(row)
    out[i_min] = SUPPRESSED
    return out
