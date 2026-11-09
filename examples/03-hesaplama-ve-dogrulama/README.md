# Örnek 3: Hesaplama ve doğrulama

## Ne öğretir
Hesaplamayı yazdırıp **bağımsız** doğrulamak: AI çıktısı kanıt değildir.

## Önkoşul
Python >= 3.11, `pip install pytest`.

## Çalıştırma
```
/new-calc Zincirleme endeks: taban 100, aylık değişimlerden seviye üret
```
```bash
cd compute && python -m pytest -q
cd compute && python -c "from tuik_calc.indices import chain_index; print(chain_index(100.0, [10.0, -10.0]))"
```
(Son komut için `PYTHONPATH=src` gerekebilir.)

## Beklenen çıktı
`[110.0, 99.0]`. Elle: 100 × 1,10 = 110; 110 × 0,90 = 99. Testler `passed`.

## Kontrol
`compute/src/tuik_calc/indices.py` ve `compute/tests/test_indices.py` dosyalarına bakın; sonucu elle de hesaplayın. Sınır durumlar (boş liste, `previous == 0`) test edilmiş mi? Formül docstring'de mi?

## Dosya haritası
`compute/src/tuik_calc/{indices,weights,disclosure,validation}.py` · `compute/tests/`. Eğitim: `docs/egitim/07-istatistik-surec-akisi.md`.
