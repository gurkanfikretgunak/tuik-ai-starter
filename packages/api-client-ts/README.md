# @tuik-ai-starter/api-client

El yazımı tipli API istemcisi. Sözleşme: `../contracts/openapi.yaml`. Akış: `.claude/skills/api-client-ts`. Test: `npm install && npm test`.

## Ne öğretir
Sözleşmeden istemciye eşitleme; hata gövdesini `ApiError` ile tiplemek; eksikleri `CLIENT_GAPS` ile görünür borç olarak tutmak (`docs/adr/0002-sozlesme-oncelikli-gelistirme.md`).

## Önkoşul
Node.js + npm.

## Çalıştırma
```bash
cd packages/api-client-ts && npm install && npm test   # vitest run
```
Beklenen: `client.test.ts` testleri geçer.

## Kullanım
```ts
import { createClient, ApiError } from "@tuik-ai-starter/api-client";
const api = createClient("http://localhost:8080");
const h = await api.health();   // { status: "ok" }
```
Durum kodu >= 400 ise `ApiError(status, code, message)` fırlatılır. Test için ikinci argümana özel `Transport` verilebilir.

## Dosya haritası
| Yol | İçerik |
|---|---|
| `src/index.ts` | `createClient`, `ApiError`, `CLIENT_GAPS` |
| `src/types.ts` | sözleşme tipleri |
| `src/client.test.ts` | testler |

## Sözleşme değişince
`/regenerate-client`: yeni uç için tip + metot ekle, `CLIENT_GAPS` güncelle, test yaz. Şu an istemcide yalnız `health()` vardır; sözleşmedeki `/series/{code}` için metot eklenmesi gerekir (doğrulanmadı: `CLIENT_GAPS` şu an boş, borç kaydedilmemiş).
