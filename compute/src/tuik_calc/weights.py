"""Ağırlıklı tahminler ve doğruluk göstergeleri."""
from __future__ import annotations

import math
from typing import Sequence


def _check(values: Sequence[float], weights: Sequence[float]) -> None:
    if len(values) != len(weights):
        raise ValueError("values ve weights aynı uzunlukta olmalı")
    if len(values) == 0:
        raise ValueError("boş girdi")
    if any(w is None or math.isnan(w) or w <= 0 for w in weights):
        raise ValueError("ağırlıklar pozitif ve sayısal olmalı")
    if any(v is None or math.isnan(v) for v in values):
        raise ValueError("eksik değer var; önce işleyin (doldurma/çıkarma kararı açık olmalı)")


def weighted_total(values: Sequence[float], weights: Sequence[float]) -> float:
    """Ağırlıklı toplam: Σ(w·y).

    >>> weighted_total([1, 2, 3], [10, 10, 10])
    60.0
    """
    _check(values, weights)
    return float(sum(v * w for v, w in zip(values, weights)))


def weighted_mean(values: Sequence[float], weights: Sequence[float]) -> float:
    """Ağırlıklı ortalama: Σ(w·y) / Σ(w).

    >>> weighted_mean([10, 20], [1, 3])
    17.5
    """
    _check(values, weights)
    return weighted_total(values, weights) / float(sum(weights))


def coefficient_of_variation(standard_error: float, estimate: float) -> float:
    """Değişim katsayısı (%): CV = SE / |tahmin| × 100.

    >>> coefficient_of_variation(2.0, 40.0)
    5.0
    """
    if estimate == 0:
        raise ValueError("tahmin 0 iken CV tanımsız")
    if standard_error < 0:
        raise ValueError("standart hata negatif olamaz")
    return standard_error / abs(estimate) * 100.0
