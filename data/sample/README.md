Bu klasör yalnızca **sentetik veya anonim** örnek veri içindir. Gerçek veri repoya girmez.

## Ne öğretir
Gerçek veri olmadan geliştirme ve test: deterministik sentetik veri, adaptör arkasında kullanım (`docs/adr/0003-veri-adaptoru-ve-sentetik-veri.md`).

## Dosyalar
| Dosya | İçerik |
|---|---|
| `ornek_seri.csv` | `donem,bolge,deger` (ör. `2024-01,A,100.0`) |
| `sentetik-seri.json` | `sentetik: true`, `seed: 42`; `gozlemler[]`: `donem`, `bolge`, `deger`, `birim_sayisi`, `durum` |

## Yeniden üretme
```bash
node scripts/generate-sample-data.mjs 42   # seed verilebilir; aynı seed aynı çıktı
```
Beklenen: `data/sample/sentetik-seri.json` yeniden yazılır (seed 42 ile aynı içerik).

## Kurallar
- Yeni dosyaya yalnızca sentetik değer; gerçek birim, kişi, firma, adres yok.
- `sentetik: true` bayrağı veya "örnek veri" notu bulunmalı; arayüzde uyarı gösterilir.
- Küçük hücre örneği gerekiyorsa `birim_sayisi` düşük sentetik satır ekle (ifşa testleri için).
- Şüphede `kvkk-kontrol` skill'ini çalıştır.
