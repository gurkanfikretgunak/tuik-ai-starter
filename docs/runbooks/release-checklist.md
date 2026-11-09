# Yayın kontrol listesi (API + web + hesaplama)

## Dağıtım sırası (sürüm farkı)
1. **Backend önce:** API'yi dağıt, veritabanı migrasyonlarını çalıştır.
2. **İstemciler:** web ve diğer istemcileri **migre edilmiş** sunucuya yönelt.
3. **Geri alma:** üretimde yedekten dönüş; `migrate down` yalnızca geçici ortamlar içindir.
4. İstemciyi, ilgili sözleşme sürümünü içeren backend yayınına karşı yayına al.

## Otomatik doğrulama
| Adım | Komut |
|---|---|
| Hook testleri | `make test-hooks` |
| Go | `cd services/api && go vet ./... && go test ./...` |
| Python | `cd compute && python -m pytest -q` |
| Web | `cd apps/web && npm test && npm run build` |
| Zafiyet | `make audit` |

## Yayın öncesi (istatistik çıktısı varsa)
- [ ] Doğrulama kuralları temiz · [ ] İfşa kontrolü yapıldı · [ ] Kalite raporu hazır
- [ ] Embargo/yayın takvimi kontrol edildi · [ ] `durum` bayrakları (geçici/kesin) doğru
- [ ] CHANGELOG ve sürüm güncel · [ ] Açık Kritik/Yüksek zafiyet yok veya gerekçeli kabul var

## Yayın sonrası
`/health` ve bir örnek uç nokta duman testi; kalite raporunu arşivle; geri bildirimleri değerlendirmeye al.
