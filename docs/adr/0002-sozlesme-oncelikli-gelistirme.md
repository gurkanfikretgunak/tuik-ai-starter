# ADR 0002: Sözleşme-öncelikli geliştirme ve el yazımı TS istemcisi
**Durum:** Kabul · **Tarih:** 2026-11-09

## Bağlam
Web (TS), backend (Go) ve hesaplama (Py) arasında tutarlılık gerekli; yapay zekâ üç katmanda aynı varsayımla kod üretmeli. Sözleşmesiz üretimde alan adları ve hata biçimleri katmanlar arasında sapar.

## Karar
1. `packages/contracts/openapi.yaml` **tek doğruluk kaynağıdır** (şu an: `/health`, `/series/{code}`; şemalar `Series`, `Observation`, `Error`). Yanına ikinci sözleşme dosyası açılmaz.
2. API değişikliği önce sözleşmede başlar; sonra Go handler/use case, sonra istemci.
3. İstemci (`packages/api-client-ts`) el yazımıdır; sözleşmede olup istemcide eksik olanlar `CLIENT_GAPS` dizisiyle görünür tutulur (görünür borç).
4. Tek koleksiyon / tek ortam dosyası ilkesi (`.claude/rules/04-ship-checklist.md`).

## Alternatifler
- Tam kod üretimi: şablon karmaşası, üretilen kodun incelenmesi zor.
- Katman başına ayrı tip tanımı: sapma riski.

## Sonuçlar
- Ship checklist sözleşme güncel mi diye sorar; `/regenerate-client` komutu istemciyi eşitler.
- Her yeni uç için: sözleşme → test → handler → istemci → `CHANGELOG.md` (`api:`).
- Sapma tespiti: sözleşme ile istemci arasındaki fark `CLIENT_GAPS` içinde yazılı olmalıdır.
- Kaynak: MasterFabric core-base pratikleri.

## İlgili
`.claude/skills/go-api-endpoint` · `.claude/skills/api-client-ts`
