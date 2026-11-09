# Şablon: py-calculation

Kopyalanacak parça: `compute`.

## Ne öğretir
Tipli, test edilmiş istatistiksel hesaplama modülleri: endeks, ağırlıklı tahmin/CV, ifşa kontrolü, doğrulama kuralları.

## Önkoşul
Python >= 3.11; test için `pip install pytest` (isteğe bağlı `ruff`). Çalışma zamanı bağımlılığı yok.

## Çalıştırma
```bash
cd compute && python -m pytest -q
cd compute && python -m ruff check .
```
Beklenen: tüm testler `passed`.

## Dosya haritası
| Yol | Fonksiyonlar |
|---|---|
| `src/tuik_calc/indices.py` | `percent_change`, `chain_index` |
| `src/tuik_calc/weights.py` | `weighted_total`, `weighted_mean`, `coefficient_of_variation` |
| `src/tuik_calc/disclosure.py` | `is_small_cell`, `is_dominated`, `suppress_row`, `secondary_suppress` |
| `src/tuik_calc/validation.py` | `check_range`, `check_required`, `check_unique`, `check_sum` |
| `tests/` | her modül için test |

Eşikler (min hücre sayısı, baskınlık payı) **parametre; kurum kararı**, koda gömülmez. Yeni modül: `/new-calc`. Örnek: `examples/03-hesaplama-ve-dogrulama`.
