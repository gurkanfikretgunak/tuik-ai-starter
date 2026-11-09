---
name: kvkk-kontrol
description: Değişikliklerde kişisel veri (KVKK), gizli istatistiki bilgi ve sır sızıntısı kontrolü; bulguyu maskeleyerek raporlar. Commit/PR öncesi, veri içeren her işte ve yeni dosya/örnek veri eklerken kullan.
---
# Veri/PII kontrolü (KVKK)

## Ne zaman
- Her commit/PR öncesi (`/ship` içinde zorunlu: `04-ship-checklist.md`).
- Örnek veri, CSV/JSON, fixture, test verisi, doküman veya log eklendiğinde.
- Bir dosya "gerçek veri olabilir" şüphesi uyandırdığında.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Kapsam | `git diff` (çalışma ağacı + staged) + yeni izlenmeyen dosyalar; "tüm repo" yalnızca istenirse |
| Betik | `bash .claude/skills/kvkk-kontrol/scan.sh [kök]`, kök varsayılan `.` |
| Dışlananlar | `.git`, `node_modules`, `.next`, `.venv` |
| Raporlama | bulgu **maskelenir**: ilk 2 + son 2 karakter, ortası `*` |
| Karar | bulgu varsa PR'ı **durdur**; kullanıcıya bildir |

Sorma; tara ve raporla. Gerçek veri bulursan değeri sohbete/loga **tekrarlama**.

## Neyi tarar (betik)
1. 11 haneli sayı (T.C. kimlik no adayı; `[1-9]` ile başlar).
2. E-posta adresi.
3. IBAN (`TR` + 24 hane, boşluklu/boşluksuz).
4. `api_key|secret|token|password` = 8+ karakterli dize.

Çıktı satırı ilk 40 karakterden sonra kısaltılır. Betik **ilk savunma hattıdır**: telefon, adres, ad-soyad, birim düzeyi kayıt, büyük CSV/parquet'i bulmaz → elle kontrol et.

## Elle kontrol listesi
- Telefon (`05xx`, `+90`), adres, doğum tarihi, ad-soyad + kimlik birlikteliği.
- Birim düzeyi (satır = kişi/işyeri) tablolar; `data/sample/` dışında veri dosyası (CSV, parquet, istatistik paketi dosyaları, SQL dökümü).
- Ortam dosyaları, anahtar dosyaları, token'lı URL; ekran görüntülerinde sır.
- Log ve notebook çıktıları.
- Yayımlanacak tabloda küçük hücre → `ifsa-kontrolu`.
- Yeni MCP/araç veriyi dış servise gönderiyor mu → `ai-risk-degerlendirme`.

## Adımlar
1. `git status --short` ve `git diff --name-only` ile kapsamı çıkar.
2. `bash .claude/skills/kvkk-kontrol/scan.sh .` çalıştır (veya yalnızca değişen klasöre).
3. Eşleşmeleri ayıkla: **yer tutucu/sentetik** (`<YER_TUTUCU>`, `ORNEK`, `0000…`) ise yanlış pozitif say ve belirt; değilse bulgu.
4. TCKN adayını sağlama ile doğrula: 10. hane = ((1,3,5,7,9. hanelerin toplamı × 7) − (2,4,6,8. hanelerin toplamı)) mod 10; 11. hane = ilk 10 hanenin toplamı mod 10. Sağlama tutmuyorsa büyük olasılıkla rastgele sayıdır.
5. Elle kontrol listesini uygula (özellikle `git diff` içindeki veri dosyaları).
6. Raporla (şablon altta). Bulgu varsa: dosyayı çıkar/maskele, git geçmişine girdiyse **dur ve sorumluya bildir** (geçmişi yeniden yazma; onaysız force push yok), sır ise anahtarı döndür.
7. Temizse "temiz" yaz ve hangi kapsamın tarandığını belirt.

## Şablon
Rapor:
```
KVKK kontrolü — kapsam: <dosya/klasör>
Sonuç: TEMİZ | <N> BULGU
| # | Dosya:satır | Tür | Maskeli değer | Durum |
|---|---|---|---|---|
| 1 | data/sample/x.csv:12 | TCKN adayı | 12*******90 | gerçek olabilir → durdur |
| 2 | docs/ornek.md:5 | e-posta | ad***@ornek.test | yer tutucu → yanlış pozitif |
Küçük hücre riski: <yok | var: açıklama>
Önerilen eylem: <...>
```
Sentetik veri örneği (yanlış pozitif sayılır): `iletisim,ad@ornek.test` ve `kimlik,<YER_TUTUCU>`.

## Örnek
Girdi: diff'te `data/sample/yeni.csv` içinde `ahmet.ornek@gmail.test,...` ve 8 haneli kodlar. Çıktı: e-posta bulgusu maskeli (`ah***@gmail.test`), "sentetik mi?" sorusu; 8 haneli kodlar 11 hane olmadığı için eşleşmez.

## Bitti kontrol listesi
- [ ] Kapsam açıkça yazıldı; betik çalıştırıldı
- [ ] Elle liste uygulandı (telefon, adres, birim düzeyi veri, sır)
- [ ] Bulgular maskelendi; gerçek değer hiçbir yerde tekrarlanmadı
- [ ] Yanlış pozitifler gerekçeyle ayrıldı
- [ ] Yayımlanacak tablo varsa `ifsa-kontrolu` çalıştı

## Sık hatalar
- Bulguyu açık değerle rapora/sohbete yazmak.
- Betiğin tek başına yeterli olduğunu sanmak.
- Yalnızca son commit'i taramak (staged ve izlenmeyen dosyaları atlamak).
- Sırrı silip anahtarı döndürmemek.
- Hook engelini atlatmak (`01-veri-gizliligi.md`).

## İlgili
`ifsa-kontrolu` · `ai-risk-degerlendirme` · `zafiyet-takibi` · `.claude/rules/01-veri-gizliligi.md` · `.claude/rules/02-guvenlik.md` · `data-privacy-auditor` ajanı · `data/sample/README.md`
