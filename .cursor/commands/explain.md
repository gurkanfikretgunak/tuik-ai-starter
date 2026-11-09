$ARGUMENTS konusunu, TÜİK personeli için sade Türkçeyle açıkla: önce büyük resim, sonra adım adım, sonda 3 kısa kontrol sorusu sor. Gereksiz jargon kullanma.

## Ne zaman
Bir dosyayı, fonksiyonu veya kavramı (örn. "ağırlıklı ortalama", "Go handler katmanı") anlamak istendiğinde.

## Argüman sözdizimi ve varsayılanlar
`/explain <dosya yolu | kavram>` — örn. `/explain compute/src/tuik_calc`.

| Eksik girdi | Varsayım |
|---|---|
| Seviye | Programlamaya yeni, istatistiğe aşina |
| Uzunluk | En fazla ~40 satır |
| Argüman yok | Son değişen dosyayı açıkla; emin değilsen tek soru sor |

## Kullanılan skill/kural
Zorunlu skill yok. İstatistik kavramı ise ilgili skill'in terimlerine bağlı kal (`agirliklandirma-ornekleme`, `endeks-hesaplama`, `ifsa-kontrolu`). Gerçek veri isteme; örneklerde `data/sample/` kullan.

## Adımlar
1. Dosya ise oku; kavram ise repoda ilgili yeri bul (Grep). Uydurma yol verme.
2. **Büyük resim:** 2–3 cümle, bu parça ne işe yarar.
3. **Adım adım:** numaralı kısa adımlar; kritik satırları `dosya:satır` ile göster.
4. **Küçük örnek:** sentetik girdi → çıktı.
5. **3 kontrol sorusu** sor; cevapları ayrıca verme, kullanıcıyı bekle.
6. Emin olmadığın noktayı "doğrulanmadı" diye belirt.

## Çıktı biçimi
```
Büyük resim: ...
Adım adım: 1) ... 2) ...
Örnek: girdi → çıktı
Sorular: 1) ... 2) ... 3) ...
```

## Örnek
`/explain services/api/internal/handler` → katmanın rolü, bir isteğin akışı, 3 soru.
`/explain değişim katsayısı` → tanım (CV = standart hata / tahmin), küçük sayısal örnek.

## Bitti kontrol listesi
- [ ] Önce büyük resim verildi.
- [ ] Jargon açıklandı veya kullanılmadı.
- [ ] Tam 3 kontrol sorusu var.

## Sık hatalar
- Kodu satır satır okuyup amacı söylememek.
- Kontrol sorularının cevabını hemen vermek.
