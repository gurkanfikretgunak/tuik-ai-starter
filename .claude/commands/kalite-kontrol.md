---
description: Hesaplama çıktısı için doğrulama ve kalite raporu taslağı üret
argument-hint: <dosya veya gösterge>
---
Hedef: $ARGUMENTS

## Ne zaman
Bir hesaplama/gösterge üretildikten sonra, yayım öncesi veya değerlendirme aşamasında.

## Argüman sözdizimi ve varsayılanlar
`/kalite-kontrol <dosya yolu | gösterge adı>` — örn. `/kalite-kontrol compute/src/tuik_calc`.

| Eksik girdi | Varsayım |
|---|---|
| Referans dönem | Verideki en son dönem |
| Tolerans | Parametre; kurum kararı (uydurma) |
| Rapor yeri | `docs/` altında `kalite-<gosterge>.md` |
| Veri | Sentetik (`data/sample/`) |

## Kullanılan skill/kural
`kalite-raporu` (şablon), `veri-temizleme`, `istatistik-gostergesi` (metaveri); kural: `.claude/rules/09-kalite-ve-dogrulama.md`, `11-metaveri-ve-siniflandirma.md`.

## Adımlar
1. Hedef çıktıyı ve üreten kodu bul; formül kaynağını not et.
2. Elle örnek: 2–3 hücreyi bağımsız hesapla.
3. Bağımsız yeniden hesap (ikinci yöntem/betik) ve karşılaştır.
4. Toplam tutarlılığı (alt toplamlar = toplam).
5. Seri/dönem kontrolü: eksik dönem, kırılma, aşırı sıçrama.
6. Rakamları betikten al (`python -m pytest -q`, kısa betik); uydurma.
7. `kalite-raporu` şablonunu doldur; yapılamayanı "doğrulanmadı" yaz.

## Çıktı biçimi
```
# Kalite raporu taslağı: <gösterge>
Doğrulama: elle örnek ✔/✘ · yeniden hesap ✔/✘ · toplam ✔/✘ · seri ✔/✘
Boyutlar: alaka, doğruluk, güncellik, dakiklik, erişilebilirlik, karşılaştırılabilirlik, tutarlılık
Açık noktalar: ...
```

## Örnek
`/kalite-kontrol zincirleme-endeks` → 4 kontrol sonucu, `docs/kalite-zincirleme-endeks.md` taslağı.

## Bitti kontrol listesi
- [ ] Dört doğrulama yapıldı ve sonuçlar yazıldı.
- [ ] Sayılar betikten, elle uydurulmadı.
- [ ] Rapor `docs/` altına yazıldı.
- [ ] Doğrulanamayanlar işaretlendi.

## Sık hatalar
- Aynı kodla "yeniden hesap" yapmak (bağımsız değil).
- Toleransı koda gömmek.
