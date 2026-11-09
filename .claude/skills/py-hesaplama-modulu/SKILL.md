---
name: py-hesaplama-modulu
description: Python'da istatistiksel/sayısal hesaplama modülü yazar (tip, docstring, doctest, pytest, bağımsız doğrulama). compute/ altında endeks, oran, ağırlıklandırma, doğrulama kuralı gibi yeni fonksiyon veya modül eklerken kullan.
---
# Python hesaplama (compute/)

## Ne zaman
`compute/src/tuik_calc/` altına yeni hesaplama, doğrulama kuralı veya yardımcı eklerken. Yönteme özel bilgi için ilgili skill'e bak: `endeks-hesaplama`, `agirliklandirma-ornekleme`, `veri-temizleme`, `ifsa-kontrolu`.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Paket | `tuik_calc` (`compute/src/tuik_calc/`), `pythonpath = ["src"]` |
| Python | `>=3.11` |
| Bağımlılık | **yok** (`dependencies = []`); pandas/numpy ekleme, standart kütüphane + `Sequence[float]` kullan. Gerekirse PR'da gerekçelendir, `make audit` çalıştır |
| Girdi türü | `Sequence[float]`, `Iterable[Mapping]` |
| Hata | geçersiz girdide `ValueError` (Türkçe mesaj) |
| Eşik/parametre | fonksiyon parametresi; **varsayılan kurum eşiği yazma** |
| Çıktı | `float` veya `dataclass(frozen=True)`; ham veriyi değiştirme |
| Veri | yalnızca sentetik |

Sorma. Formül tartışmalıysa (ör. endeks türü) varsayımı docstring'e yaz.

## Gerçek yapı (doğrulandı)
`__init__.py` fonksiyonları dışa aktarır ve `__all__` listeler. Mevcut: `indices.py` (`percent_change`, `chain_index`), `weights.py` (`weighted_total`, `weighted_mean`, `coefficient_of_variation`), `disclosure.py` (`is_small_cell`, `is_dominated`, `suppress_row`, `secondary_suppress`, `SUPPRESSED`), `validation.py` (`Finding`, `check_range/required/unique/sum`). Testler: `compute/tests/test_<modul>.py`.

## Adımlar
1. Hangi modüle ait olduğuna karar ver (yoksa yeni `compute/src/tuik_calc/<ad>.py`).
2. **Önce test yaz:** elle hesaplanmış beklenen değerle (aşağıdaki şablon).
3. Fonksiyonu yaz: `from __future__ import annotations`, tam tip ipuçları.
4. Docstring: formül, birim, sınır durumları, `>>>` doctest örneği.
5. Sınır durumlarını kararlaştır ve test et: boş girdi, uzunluk uyuşmazlığı, NaN/None, sıfıra bölme, negatif.
6. `__init__.py` içine import ve `__all__` girdisi ekle.
7. **Bağımsız doğrula:** sonucu ikinci yolla kontrol et (elle hesap, farklı formül, özellik testi). AI çıktısı kanıt değildir.
8. Çalıştır: `cd compute && python -m pytest -q` ve `python -m pytest --doctest-modules src -q`; lint: `python -m ruff check .`.
9. Formül/metodoloji değiştiyse `CHANGELOG.md` → `- compute: ...`; eski sonuçları etkileyen değişiklik **MAJOR** (PR'da yaz).

## Şablon

Modül (`compute/src/tuik_calc/ratios.py`):
```python
"""Oran hesapları (örnek)."""
from __future__ import annotations

import math


def share_pct(part: float, whole: float) -> float:
    """Pay (%): part / whole × 100.

    >>> share_pct(25.0, 200.0)
    12.5
    """
    if any(math.isnan(x) for x in (part, whole)):
        raise ValueError("eksik değer var; önce işleyin")
    if whole == 0:
        raise ValueError("whole sıfır olamaz")
    if part < 0 or whole < 0:
        raise ValueError("negatif değer desteklenmiyor")
    return part / whole * 100.0
```

Test (`compute/tests/test_ratios.py`):
```python
import pytest
from tuik_calc.ratios import share_pct


def test_share_hand_calculated():
    assert share_pct(25, 200) == pytest.approx(12.5)


@pytest.mark.parametrize("part,whole", [(1, 0), (-1, 5), (float("nan"), 5)])
def test_share_invalid_inputs(part, whole):
    with pytest.raises(ValueError):
        share_pct(part, whole)


def test_share_independent_check():
    # ikinci yol: pay + kalan pay = 100
    assert share_pct(30, 120) + share_pct(90, 120) == pytest.approx(100.0)
```

`__init__.py` ekleme:
```python
from .ratios import share_pct
# __all__ listesine "share_pct" ekle
```

## Örnek (sentetik)
Girdi: `weighted_mean([10, 20], [1, 3])` → `17.5` (elle: (10·1 + 20·3) / 4 = 17,5). `percent_change(110.0, 100.0)` → `10.0`. `chain_index(100.0, [10.0, -10.0])` → `[110.0, 99.0]`.

## Bitti kontrol listesi
- [ ] Tip ipuçları + Türkçe docstring (formül, birim, doctest)
- [ ] Başarılı yol, elle hesaplanmış değer, her hata yolu için test
- [ ] Bağımsız doğrulama yapıldı ve testte kaydedildi
- [ ] `__init__.py` dışa aktarımı güncel
- [ ] `python -m pytest -q` ve ruff temiz
- [ ] Kurum eşiği koda gömülmedi
- [ ] `CHANGELOG.md` `compute:` satırı; sonuçları değiştiriyorsa MAJOR belirtildi

## Sık hatalar
- Sıfıra bölme ve boş girdiyi sessizce `0` döndürmek.
- NaN'ı yutmak; eksik değer kararı açık olmalı.
- Sabit eşik/ağırlık gömmek (`min_count=3` gibi); parametre yap.
- Float eşitliğini `==` ile test etmek → `pytest.approx`.
- Sonucu yalnızca kendi koduyla "doğrulamak".
- Gerçek veriyle deneme yapmak.

## İlgili
`/new-calc` · `endeks-hesaplama` · `agirliklandirma-ornekleme` · `veri-temizleme` · `ifsa-kontrolu` · `kalite-raporu` · `compute/CLAUDE.md` · `.claude/rules/04-ship-checklist.md`
