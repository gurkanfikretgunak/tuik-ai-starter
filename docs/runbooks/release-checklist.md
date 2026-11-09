# Yayın kontrol listesi (API + web + hesaplama)

## Ne zaman
Bir sürüm yayına alınmadan önce. Sıra: otomatik doğrulama → yayın öncesi kontrol → dağıtım → yayın sonrası.

## Dağıtım sırası (sürüm farkı)
1. **Backend önce:** API'yi dağıt, veritabanı migrasyonlarını çalıştır.
2. **İstemciler:** web ve diğer istemcileri **migre edilmiş** sunucuya yönelt.
3. **Geri alma:** üretimde yedekten dönüş; `migrate down` yalnızca geçici ortamlar içindir.
4. İstemciyi, ilgili sözleşme sürümünü içeren backend yayınına karşı yayına al.

## Otomatik doğrulama
| Adım | Komut |
|---|---|
| Ortam | `make doctor` |
| Hook testleri | `make test-hooks` |
| Go | `cd services/api && go vet ./... && go test ./...` |
| Python | `cd compute && python -m pytest -q` |
| Web | `cd apps/web && npm test && npm run build` |
| TS istemci | `cd packages/api-client-ts && npm test` |
| Zafiyet | `make audit` |
Hepsi tek seferde: `make lint test test-hooks audit` (veya `/ship`).

## Sürüm ve değişiklik günlüğü
- `CHANGELOG.md`: yeni sürüm başlığı + `### Eklendi / Değişti / Düzeltildi`; önekler `api:`, `web:`, `compute:`, `contracts:`, `ai:`.
- Web görünür değişiklikte `apps/web/package.json` sürümü artar (`.claude/rules/05-surumleme.md`).
- Sözleşme değiştiyse `packages/contracts/openapi.yaml` güncel ve istemci eşit (`CLIENT_GAPS` gözden geçirildi).

## Yayın öncesi (istatistik çıktısı varsa)
- [ ] Doğrulama kuralları temiz · [ ] İfşa kontrolü yapıldı · [ ] Kalite raporu hazır
- [ ] Embargo/yayın takvimi kontrol edildi · [ ] `durum` bayrakları (geçici/kesin) doğru
- [ ] CHANGELOG ve sürüm güncel · [ ] Açık Kritik/Yüksek zafiyet yok veya gerekçeli kabul var
- [ ] Hesaplama formülü değiştiyse eski sonuçlara etkisi PR'da yazılı (MAJOR)

## Yayın sonrası
1. `/health` duman testi (örn. `curl -s http://localhost:8080/health` yerelde; üretimde kurumun adresi).
2. Bir örnek uç nokta: `/series/<KOD>`.
3. Kalite raporunu arşivle; geri bildirimleri değerlendirmeye al.

## Sık hatalar
- Web'i backend'den önce yayına almak (istemci olmayan alanı bekler).
- Üretimde `migrate down` çalıştırmak.
- İfşa kontrolünü "sonra yaparız" diye atlamak.

## İlgili
`.claude/rules/04-ship-checklist.md` · `.claude/skills/yayin-ve-revizyon` · `docs/security/zafiyet-kayitlari.md`
