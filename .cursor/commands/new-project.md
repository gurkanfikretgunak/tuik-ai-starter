`proje-baslat` skill'ini kullanarak yeni proje başlat. Argümanlar: $ARGUMENTS

## Ne zaman
Sıfırdan yeni proje, PRD veya iskelet gerektiğinde.

## Argüman sözdizimi ve varsayılanlar
`/new-project <proje-adı> [web|api|calc|fullstack]`

| Tür | Şablon (`templates/`) |
|---|---|
| web | `web-dashboard` |
| api | `go-service` |
| calc | `py-calculation` |
| fullstack | `fullstack-minimal` |

| Eksik girdi | Varsayım |
|---|---|
| Tür | `fullstack` |
| Ad | Kullanıcıdan al (tek kritik girdi); küçük harf, tire |
| Veri | Kamuya açık/sentetik varsay; hassas denirse kuralları hatırlat |
| Hedef klasör | `projects/<ad>/` (yoksa oluştur) |

## Kullanılan skill/kural
`proje-baslat` (ana); isteğe göre `gsbpm-surec-haritasi`, `tasarim-dokumani`, `ai-risk-degerlendirme`. Kural: `.claude/rules/01-veri-gizliligi.md`. Şablon rehberi: `templates/README.md`.

## Adımlar
1. En fazla 4 kısa soru: hedef kullanıcı, çözülecek problem, veri türü (kamuya açık/hassas), başarı ölçütü. Cevap yoksa varsayılanı yaz.
2. Veri hassassa `01-veri-gizliligi.md` kurallarını baştan hatırlat; `/ai-risk` öner.
3. `docs/` altında kısa PRD (`prd.md`) üret: problem, kullanıcı, kapsam, kapsam dışı, başarı ölçütü.
4. Uygun şablonu `templates/` içinden `projects/<ad>/` altına kopyala.
5. Plan çıkar (3–7 madde), onay iste, sonra ilk işi uygula.
6. `make test` çalıştır, sonucu raporla.

## Çıktı biçimi
PRD yolu, seçilen şablon, oluşan klasör ağacı, test sonucu, sıradaki 3 adım.

## Örnek
`/new-project enflasyon-izleme web` → `web-dashboard` kopyalanır, PRD yazılır, ilk sayfa planlanır.
`/new-project anket-hesap calc` → `py-calculation` şablonu.

## Bitti kontrol listesi
- [ ] PRD yazıldı.
- [ ] Şablon kopyalandı, adlar güncellendi.
- [ ] `make test` sonucu raporlandı.
- [ ] Gerçek veri/sır eklenmedi.

## Sık hatalar
- 4'ten fazla soru sormak.
- Şablonu kopyalarken eski proje adını bırakmak.
