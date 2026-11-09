---
name: api-client-ts
description: packages/api-client-ts — el yazımı, tipli TS API istemcisini sözleşme (OpenAPI) değişince güncelleme ve web tüketicilerini eşitleme akışı. Backend sözleşmesi değiştiğinde kullan.
---
# TS API istemcisi
(MasterFabric `masterfabric-api-ts` pratiğinden uyarlanmıştır.)
- Konum: `packages/api-client-ts/`; **el yazımıdır**, üretilmez. Kaynak gerçek: `packages/contracts/openapi.yaml`.
- Akış: (1) sözleşmeyi güncelle → (2) `src/types.ts` ve ilgili servis fonksiyonunu uyarla → (3) test ekle → (4) `apps/web` kullanımlarını güncelle → (5) `CHANGELOG.md` (`contracts:` / `web:`).
- İstemci taşıyıcı (transport) enjekte edilir (`fetch` varsayılan) → testte sahte taşıyıcı kullanılır.
- Hata biçimi sözleşmedeki `Error` şemasıdır; istemci `ApiError` fırlatır.
- Sözleşmede olup istemcide henüz olmayan işlemler `CLIENT_GAPS` listesinde tutulur (görünür borç).
