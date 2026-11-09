---
name: kod-inceleme
description: Kod inceleme kontrol listesi: veri gizliliği, doğruluk, güvenlik, test, okunabilirlik; Go, TypeScript ve Python'a özel noktalarla. Commit/PR öncesi ve /review akışında kullan.
---
# Kod inceleme listesi

## Ne zaman
`/review`, `/ship` öncesi, başkasının PR'ını okurken veya AI'nın yazdığı kodu teslim almadan önce. Kod yazmaz, bulgu üretir.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Kapsam | `git diff` + `git diff --staged`; boşsa `git diff main...HEAD` |
| Sıra | veri gizliliği > güvenlik > doğruluk > test > okunabilirlik |
| Çıktı | Kritik / Önemli / Öneri; her biri `dosya:satır` + somut düzeltme |
| Dil | bulgular Türkçe |

Sorma; farkı oku, her bulgu için satırı doğrula (kanıtsız bulgu yazma).

## Adımlar
1. `git status --short`, `git diff --stat` ile değişen dosyaları listele.
2. Önce **veri gizliliği**: gerçek veri, kişisel veri, sır, ham veri klasörü, ortam dosyası var mı → `kvkk-kontrol` betiğini çalıştır; değeri maskele.
3. **Güvenlik**: dış girdi sunucuda doğrulanıyor mu; enjeksiyon; yetki; hata mesajı iç bilgi sızdırıyor mu.
4. **Doğruluk**: sınır durumları, hata yönetimi, sözleşme (`packages/contracts/openapi.yaml`) uyumu.
5. **Test**: yeni davranış başına başarı + hata yolu; test adı davranışı anlatıyor mu; gerçek veri yok.
6. **Okunabilirlik**: isimler, gereksiz karmaşıklık, ölü kod, dil kuralı (kod İngilizce, metin Türkçe).
7. **Ship kuralları**: CHANGELOG satırı, sürüm artışı, sözleşme güncel mi (`04-ship-checklist.md`).
8. Bulguları yaz, karar ver: "Birleştirilebilir" veya "Düzeltme gerekli".

## Dile özel noktalar
| Alan | Bak |
|---|---|
| Go (`services/api`) | `ctx` ilk parametre; hata `%w` ile sarılı; `errors.Is` ile eşleme; handler'da iş mantığı yok; ham `err.Error()` yanıta yazılmıyor; SQL parametreli; hata yanıtı `{"error":{"code","message"}}`; gizli hücre `nil`, 0 değil |
| TS/Next (`apps/web`) | `dangerouslySetInnerHTML` yok; `"use client"` gereksiz yayılmamış; `toLowerCase()` ile Türkçe arama yok (`foldTr`); sayılar `formatNumber`/`tr-TR`; `params` `await` ediliyor (Next 15); metinler TR |
| Python (`compute`) | tip ipuçları; sıfıra bölme/boş/NaN açık hata; eşik gömülmemiş; `shell=True`/`eval` yok; test `pytest.approx` |
| İstatistik | gizli hücre 0'a çevrilmemiş; küçük hücre/ifşa kontrolü; kaynak/dönem/birim belirtilmiş |
| Bağımlılık | gerçekten var mı, bakım ve lisans; `make audit`, kayıt `ZAF-...` |

## Şablon
```
Karar: Birleştirilebilir | Düzeltme gerekli
Kritik:
 1) services/api/internal/handler/x.go:42 — err.Error() istemciye dönüyor (iç bilgi sızar)
    Düzeltme: sabit mesaj "beklenmeyen hata" yaz, ayrıntıyı logla (veri olmadan)
Önemli:
 1) compute/src/tuik_calc/foo.py:10 — whole=0 için test yok → ValueError testi ekle
Öneri:
 1) apps/web/src/app/x/page.tsx:8 — sayı toFixed ile; formatNumber kullan
Eksik test: <...>
```

## Örnek
Girdi: diff'te `deger: g.deger ?? 0` (TS). Bulgu: **Kritik** — gizli hücre 0'a dönüşüyor; düzeltme: `null`'ı koru, arayüzde "gizli" yaz.

## Bitti kontrol listesi
- [ ] Tüm değişen dosyalar okundu
- [ ] Veri gizliliği taraması yapıldı (bulgular maskeli)
- [ ] Her bulguda `dosya:satır` + düzeltme var
- [ ] Test boşlukları belirtildi
- [ ] Karar cümlesi yazıldı

## Sık hatalar
- Yalnızca stil bulgusu yazıp güvenliği atlamak.
- Satırı doğrulamadan bulgu yazmak.
- Bulguda gerçek değeri (sır/PII) açıkça yazmak.
- AI'nın "test geçti" demesini kanıt saymak; testi kendin çalıştır.
- İlgisiz refactor'ü "öneri" diye PR'ı büyütmek.

## İlgili
`/review` · `reviewer` ajanı · `kvkk-kontrol` · `zafiyet-takibi` · `.claude/rules/01-veri-gizliligi.md` · `.claude/rules/02-guvenlik.md` · `.claude/rules/test.md`
