# ADR 0002: Sözleşme-öncelikli geliştirme ve el yazımı TS istemcisi
**Durum:** Kabul · **Tarih:** 2026-11-09
**Bağlam:** Web (TS), backend (Go) ve hesaplama (Py) arasında tutarlılık; yapay zekâ üç katmanda aynı varsayımla kod üretmeli.
**Karar:** `packages/contracts/openapi.yaml` tek doğruluk kaynağıdır. İstemci (`packages/api-client-ts`) el yazımıdır; eksikler `CLIENT_GAPS` ile görünür tutulur. Tek koleksiyon/tek sözleşme dosyası ilkesi.
**Alternatifler:** Tam kod üretimi (şablon karmaşası), katman başına ayrı tip tanımı (sapma riski).
**Sonuçlar:** API değişikliği önce sözleşmede başlar; ship checklist bunu zorlar. Kaynak: MasterFabric core-base pratikleri.
