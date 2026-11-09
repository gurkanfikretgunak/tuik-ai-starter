---
paths:
  - "compute/**"
---
# Kalite ve doğrulama
- Her hesaplama için: (1) elle hesaplanmış küçük örnek, (2) bağımsız ikinci yöntem veya yeniden hesap, (3) sınır durumları (boş, NaN, sıfır, negatif, tek gözlem).
- Toplam tutarlılığı: kırılımların toplamı genel toplamla uyuşmalı (yuvarlama toleransı açıkça belirtilir).
- Dönem/seri kontrolü: eksik dönem, çift kayıt, birim değişimi, seri kırılması.
- Yapay zekâ ürettiği formülü kaynakla doğrula; "kendinden emin" cevap kanıt değildir.
- Sayısal karşılaştırmada `==` yerine tolerans (`pytest.approx`).
- Doğrulama kuralları adlandırılır ve raporlanır; sessizce düzeltme yapılmaz.

## Minimum doğrulama seti
| Kontrol | Örnek (sentetik) |
|---|---|
| Elle hesap | `weighted_mean([1,2,3],[1,1,2])` = 2.25 |
| Bağımsız ikinci yöntem | toplam/ağırlık toplamı ile kıyas |
| Sınır: boş girdi | `ValueError` bekle |
| Sınır: sıfıra bölme | açık hata, sessiz `inf` yok |
| Sınır: tek gözlem | tanımsızsa açıkça belirt |
| Toplam tutarlılığı | `check_sum(rows, parts, total, tol)` |

```python
import pytest
def test_weighted_mean_matches_manual_calc():
    assert weighted_mean([1, 2, 3], [1, 1, 2]) == pytest.approx(2.25)
```
Mevcut doğrulayıcılar: `compute/src/tuik_calc/validation.py` (`check_range`, `check_required`, `check_unique`, `check_sum`).

## Do / Don't
- DO: kuralı adlandır ve raporla (`Finding`). DON'T: sessizce düzelt.
- DO: `pytest.approx` / tolerans. DON'T: float `==`.
- DON'T: AI'ın verdiği formülü kaynaksız kabul et; kaynak yoksa "doğrulanmadı" yaz.
