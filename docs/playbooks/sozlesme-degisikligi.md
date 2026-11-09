# Playbook: API sözleşmesi değişikliği

**Ne zaman:** Yeni uç, alan ekleme/çıkarma veya hata kodu değişikliği.

## Adımlar
1. `packages/contracts/openapi.yaml` içinde değişikliği yap (tek sözleşme dosyası).
2. Geriye uyumlu mu? Alan ekleme uyumludur; alan silme/yeniden adlandırma **uyumsuzdur** → PR'da açıkça yaz.
3. Go tarafı: `go-api-endpoint` skill'i (`internal/application/<usecase>` → handler → test).
4. İstemci: `/regenerate-client` (`packages/api-client-ts`: tip + metot + test; `CLIENT_GAPS` güncelle).
5. Web tüketicilerini eşitle (`apps/web/src/lib/data`).
6. `CHANGELOG.md`: `api:` ve gerekiyorsa `web:` satırı.
7. Yayın sırası: **önce API, sonra istemci/web**.

## Bitti kontrol listesi
- [ ] Sözleşme, handler ve istemci aynı alan adlarını kullanıyor.
- [ ] Hata yolu için test var (400/404 vb.).
- [ ] `make test` temiz.
