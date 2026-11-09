---
name: ifsa-kontrolu
description: Yayımlanacak tablo/API/grafikte istatistiki ifşa kontrolü (küçük hücre, baskınlık, ikincil bastırma) yapar ve hücreleri "gizli" kodlar. Tablo, API veya grafik yayımlamadan önce her zaman kullan.
---
# İstatistiki ifşa kontrolü (GSBPM 7)

Amaç: tek bir birimin (kişi/işletme) değeri tablodan çıkarılamasın. **Eşikler kurum kararıdır; kodda varsayılan yoktur**, parametre olarak verilir.

## Ne zaman
Her yayın öncesi: tablo, grafik, API yanıtı, dışa aktarım. Filtre/kırılım eklendiğinde yeniden.

## Girdiler ve varsayılanlar
| Girdi | Eksikse |
|---|---|
| `min_count` (en az birim) | **sorma, uydurma**: yapılandırmadan oku; yoksa "eşik bekleniyor" yaz ve kontrolü yalnızca yapıyı doğrulayarak tamamla. Örnek/test için `3` kullanılabilir (**yalnızca test; kurum eşiği değil**) |
| `top_n`, `max_share` (baskınlık) | aynı: parametre; kurum kararı. Test örneği: `1`, `0.8` |
| Hücre birim sayıları | tabloda `birim_sayisi` sütunu (`data/sample/sentetik-seri.json` biçimi) |
| Hücre birim değerleri | baskınlık için gerekir; yoksa baskınlık kontrolü "yapılamadı" diye raporlanır |
| Toplam | satır/sütun toplamı açıksa ikincil bastırma uygulanır |

## Fonksiyonlar (`compute/src/tuik_calc/disclosure.py`)
| İmza | Davranış |
|---|---|
| `SUPPRESSED = "gizli"` | bastırma kodu |
| `is_small_cell(count, min_count) -> bool` | `count < min_count`; `min_count<1` → `ValueError` |
| `is_dominated(unit_values, top_n, max_share) -> bool` | en büyük `top_n` birim toplamın `max_share`'inden fazlaysa True; toplam ≤0 → False; geçersiz parametre → `ValueError` |
| `suppress_row(values, counts, min_count) -> list` | `counts` eşik altındaki hücreyi `"gizli"` yapar (birincil); uzunluk farkı → `ValueError` |
| `secondary_suppress(row, total) -> list` | tam **1** gizli hücre + açık toplam varsa en küçük görünür sayısal hücreyi de gizler; `total=None` ise dokunmaz |

## Adımlar
1. Tablonun kırılım eksenlerini ve her hücrenin birim sayısını çıkar.
2. Eşikleri yapılandırmadan al (kurum kararı).
3. Birincil: `suppress_row(values, counts, min_count)`.
4. Baskınlık: hücre başına birim değerleri varsa `is_dominated(...)`; True ise hücreyi `SUPPRESSED` yap.
5. İkincil: toplam yayımlanıyorsa `secondary_suppress(row, total)`. Not: yalnızca **tek** gizli hücre durumunu ele alır; birden fazla gizli hücre veya sütun toplamları (iki yönlü tablo) için ek kontrol yazıp test et.
6. Çıktıda bastırılan hücre `"gizli"`; `0`, boş, `NaN` yok. API sözleşmesinde `value: null` + `status: gizli` (`packages/contracts/openapi.yaml`, `Observation`).
7. Kırılım derinleştikçe (il × sektör × büyüklük) ve API filtre kombinasyonlarında yeniden uygula; sorgu sınırı sunucuda.
8. Sayıları `kalite-raporu`'na yaz: bastırılan hücre sayısı/oranı, hangi kural.

## Şablon
```python
from tuik_calc.disclosure import suppress_row, secondary_suppress, is_dominated, SUPPRESSED

row = suppress_row(values, counts, min_count=MIN_COUNT)       # MIN_COUNT yapılandırmadan
for i, units in enumerate(unit_values_per_cell):              # biliniyorsa
    if row[i] != SUPPRESSED and is_dominated(units, TOP_N, MAX_SHARE):
        row[i] = SUPPRESSED
row = secondary_suppress(row, total=row_total)
n_hidden = sum(v == SUPPRESSED for v in row)
```

## Örnek (sentetik)
`suppress_row([10.0, 20.0, 30.0], [5, 2, 9], min_count=3)` → `[10.0, 'gizli', 30.0]`
`secondary_suppress([10.0, 'gizli', 30.0], total=60.0)` → `['gizli', 'gizli', 30.0]`
`is_dominated([90, 5, 5], top_n=1, max_share=0.8)` → `True` · `is_small_cell(2, 3)` → `True`

## Bitti kontrol listesi
- [ ] Eşikler yapılandırmadan; kodda sabit yok.
- [ ] Birincil, baskınlık, ikincil sırayla uygulandı.
- [ ] Bastırılanlar `gizli`; `0`/boş/NaN yok.
- [ ] Toplam/kenar toplamlarından geri hesap denendi.
- [ ] API/filtre kombinasyonları ve ham/birim düzeyi uçlar kontrol edildi.
- [ ] Bastırma özeti kalite raporunda.
- [ ] Test: başarılı yol + hata yolu (`min_count=0`).

## Sık hatalar
- Eşiği kodda sabitlemek veya test eşiğini kurum eşiği sanmak.
- Gizli hücreyi 0 yazmak.
- Toplamı yayımlayıp ikincil bastırmayı atlamak.
- Yalnız tabloyu kontrol edip API filtrelerini unutmak.
- Hücre kırılımını artırıp (il×sektör) yeniden kontrol etmemek.

## İlgili
`compute/src/tuik_calc/disclosure.py` · `compute/tests/test_disclosure.py` · `.claude/rules/10-ifsa-kontrolu.md`, `01-veri-gizliligi.md` · `/ifsa-kontrol` · skill: `kalite-raporu`, `yayin-ve-revizyon`. Yasal çerçeve ve eşikte son söz kurumun ilgili biriminindir.
