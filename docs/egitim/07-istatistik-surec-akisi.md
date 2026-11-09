# 7. İstatistik üretim süreci ve AI
**Seviye:** Orta · **Süre:** 60 dk

## Öğrenme hedefi
Bir işi GSBPM aşamalarına eşlemek ve her aşamada doğru skill'i çalıştırmak; ağırlıklı tahmin, CV, ifşa kontrolü ve yayım adımlarını sentetik veriyle denemek.

## GSBPM aşaması → skill
| Aşama | Skill / komut |
|---|---|
| İhtiyaç, tasarım | `gsbpm-surec-haritasi`, `istatistik-gostergesi`, `siniflandirma-esleme` |
| Yapılandırma, toplama | `gsbpm-surec-haritasi` (araç ve sözleşme) |
| İşleme | `veri-temizleme` (`compute/src/tuik_calc/validation.py`) |
| Analiz | `agirliklandirma-ornekleme` (`weights.py`), `endeks-hesaplama` (`indices.py`) |
| Yayım | `ifsa-kontrolu` (`disclosure.py`), `yayin-ve-revizyon` |
| Değerlendirme | `kalite-raporu` (`/kalite-kontrol`) |

Kurumsal eşik ve yöntemler koda gömülmez: eşikler (ör. minimum hücre sayısı) **parametre; kurum kararı**.

## Adım adım alıştırma
1. `/new-surec` ile küçük bir gösterge seçin (sentetik: `data/sample/sentetik-seri.json`).
2. Aşamalara eşleyin; her aşama için çıktı, kontrol, sorumlu araç yazdırın.
3. Doğrulama: aralık, zorunlu alan, tekillik, toplam tutarlılığı (`check_range`, `check_required`, `check_unique`, `check_sum`).
4. Tahmin: `weighted_mean(values, weights)`; `coefficient_of_variation(standard_error, estimate)` = SE / tahmin × 100 (standart tanım).
5. Endeks: `chain_index(100.0, [2.5, -1.0])` — sonucu elle hesaplayın: 100 → 102.5 → 101.475.
6. İfşa: `is_small_cell(count, min_count)` ile `min_count`'u **parametre** olarak verin; `suppress_row` ve `secondary_suppress` ile bastırın.
7. Karşılaştırma: `cd compute && python -m pytest -q` çıktısı ve `examples/03-hesaplama-ve-dogrulama`.

## Örnek prompt'lar
**Kötü:** `Verileri temizle ve yayımla.`
**İyi:**
```
/new-surec
Gösterge: aylık fiyat endeksi (sentetik, data/sample/ornek_seri.csv). Aşamaları GSBPM'ye eşle.
Her aşama için: çıktı, kontrol, kullanılacak skill. İfşa eşiği parametre olsun (<ESIK>, kurum kararı).
Yayımdan önce ifsa-kontrolu ve kalite-raporu adımlarını listele. Kod yazma, yalnız plan.
```

## Kontrol soruları
1. CV neyi ölçer ve hangi iki girdiyle hesaplanır?
2. İkincil bastırma neden gerekir? (Toplam biliniyorsa tek bastırılmış hücre geri hesaplanabilir.)
3. Geçici ve kesin veri nasıl işaretlenir ve revizyon nerede yönetilir?

## İlgili
`.claude/rules/08–12` · `docs/runbooks/release-checklist.md`
