Argüman almaz. `packages/contracts/openapi.yaml` değiştiğinde TS istemcisini ve web kullanımlarını eşitler.

## Ne zaman
Sözleşmede yol, şema veya hata kodu eklendi/değişti/silindi.

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| Fark kaynağı | `git diff -- packages/contracts/openapi.yaml` |
| İstemci | El yazımı, tipli: `packages/api-client-ts/src` |
| Tüketici | `apps/web/src` |
| Kırıcı değişiklik | Tüketicileri güncelle, listele |

## Kullanılan skill/kural
`api-client-ts` (ana). Kurallar: `.claude/rules/04-ship-checklist.md`, `web-nextjs.md`. Rehber: `packages/api-client-ts/README.md`.

## Adımlar
1. Sözleşme farkını oku; eklenen/değişen/silinen uçları listele.
2. `packages/api-client-ts/src` içinde tipleri ve çağrı fonksiyonlarını güncelle.
3. İstemci testlerini güncelle (`cd packages/api-client-ts && npm test`, script varsa).
4. `apps/web/src` içinde eski kullanımları Grep ile bul, güncelle.
5. `make test`, ardından `cd apps/web && npm test`.
6. Web davranışı değiştiyse `apps/web/package.json` sürümü ve `CHANGELOG.md` (`web:`).

## Çıktı biçimi
Sözleşme farkı özeti → güncellenen istemci dosyaları → güncellenen web dosyaları → test sonuçları.

## Örnek
`/regenerate-client` (sözleşmeye `GET /v1/seriler/{id}` eklendi) → `getSeries(id)` eklenir, tipler yazılır, web'de kullanım örneği güncellenir.

## Bitti kontrol listesi
- [ ] İstemci tipleri sözleşmeyle birebir.
- [ ] Web'de eski kullanım kalmadı.
- [ ] Backend ve web testleri geçiyor.

## Sık hatalar
- İstemciyi sözleşmeye bakmadan elle uydurmak.
- Silinen uç için tüketiciyi unutmak.
