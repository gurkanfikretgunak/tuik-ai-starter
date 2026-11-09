# compute (Python)
Yeni hesaplama için `/new-calc`. Test: `python -m pytest`. Yalnızca sentetik veri.

## Dizin haritası
| Yol | İçerik |
|---|---|
| `src/tuik_calc/indices.py` | `percent_change`, `chain_index` |
| `src/tuik_calc/weights.py` | `weighted_total`, `weighted_mean`, `coefficient_of_variation` |
| `src/tuik_calc/disclosure.py` | `is_small_cell`, `is_dominated`, `suppress_row`, `secondary_suppress` |
| `src/tuik_calc/validation.py` | `Finding`, `check_range/required/unique/sum` |
| `tests/test_*.py` | modül başına test (`test_indices.py`, `test_weights.py`, ...) |
| `notebooks/` | keşif; commit öncesi çıktı temizlenir |
| `pyproject.toml` | Python >=3.11, pytest (`pythonpath=src`), ruff (satır 100) |

## Komutlar
- Test: `cd compute && python -m pytest -q` · Lint: `python -m ruff check .` · Hepsi: `make test`, `make lint`.

## Adlandırma ve test deseni
- Dosya/fonksiyon `snake_case`, tip ipuçları zorunlu; saf fonksiyon. Test: `test_<ne>_<koşul>` (örn. `test_percent_change_raises_on_zero_previous`).
- Her fonksiyon için: elle hesap örneği, hata yolu (boş/sıfıra bölme), `pytest.approx`. Yalnızca sentetik veri.

## Yaygın görev → dosya
| Görev | Yap |
|---|---|
| Yeni hesap | `src/tuik_calc/<modül>.py` + `tests/test_<modül>.py` (`/new-calc`) |
| Endeks/değişim | `indices.py` |
| Ağırlık/CV | `weights.py` |
| İfşa/bastırma | `disclosure.py` (eşik parametre; kurum kararı) |
| Doğrulama kuralı | `validation.py` |
| Formül değişti | docstring + CHANGELOG `compute:`; sonuç etkileniyorsa MAJOR |
Kurallar: `.claude/rules/hesaplama-python.md`, `09-kalite-ve-dogrulama.md`, `10-ifsa-kontrolu.md`.
