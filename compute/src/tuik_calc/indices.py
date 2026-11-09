"""Basit endeks hesaplamaları (örnek modül)."""
from __future__ import annotations


def percent_change(current: float, previous: float) -> float:
    """Yüzde değişim: (current - previous) / previous * 100.

    >>> percent_change(110.0, 100.0)
    10.0
    """
    if previous == 0:
        raise ValueError("previous sıfır olamaz")
    return (current - previous) / previous * 100.0


def chain_index(base: float, changes_pct: list[float]) -> list[float]:
    """Taban değerden başlayarak yüzde değişimlerle zincirleme endeks üretir.

    >>> chain_index(100.0, [10.0, -10.0])
    [110.0, 99.0]
    """
    out: list[float] = []
    level = base
    for c in changes_pct:
        level = level * (1 + c / 100.0)
        out.append(round(level, 10))
    return out
