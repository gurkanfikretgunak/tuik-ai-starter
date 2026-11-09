"""Adlandırılmış doğrulama kuralları (ham veriyi değiştirmez, yalnızca bulgu döndürür)."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, Mapping


@dataclass(frozen=True)
class Finding:
    rule: str
    row: int
    message: str


def check_range(rows: Iterable[Mapping], field: str, lo: float, hi: float) -> list[Finding]:
    """V001: alan değeri [lo, hi] aralığında olmalı (eksik değer ayrı kuralda).

    >>> check_range([{"x": 5}, {"x": 500}], "x", 0, 100)
    [Finding(rule='V001', row=1, message='x=500 aralık dışı [0, 100]')]
    """
    out = []
    for i, r in enumerate(rows):
        v = r.get(field)
        if isinstance(v, (int, float)) and not lo <= v <= hi:
            out.append(Finding("V001", i, f"{field}={v} aralık dışı [{lo:g}, {hi:g}]"))
    return out


def check_required(rows: Iterable[Mapping], field: str) -> list[Finding]:
    """V002: zorunlu alan boş olamaz."""
    return [Finding("V002", i, f"{field} eksik") for i, r in enumerate(rows) if r.get(field) in (None, "")]


def check_unique(rows: Iterable[Mapping], field: str) -> list[Finding]:
    """V003: alan değeri tekil olmalı."""
    seen: dict = {}
    out = []
    for i, r in enumerate(rows):
        v = r.get(field)
        if v in seen:
            out.append(Finding("V003", i, f"{field}={v} yineleniyor (ilk: satır {seen[v]})"))
        else:
            seen[v] = i
    return out


def check_sum(rows: Iterable[Mapping], parts: list[str], total: str, tol: float = 1e-6) -> list[Finding]:
    """V004: parçaların toplamı genel toplama eşit olmalı (tolerans açık)."""
    out = []
    for i, r in enumerate(rows):
        vals = [r.get(p) for p in parts] + [r.get(total)]
        if all(isinstance(v, (int, float)) for v in vals):
            s = sum(vals[:-1])
            if abs(s - vals[-1]) > tol:
                out.append(Finding("V004", i, f"Σ{parts}={s:g} ≠ {total}={vals[-1]:g}"))
    return out
