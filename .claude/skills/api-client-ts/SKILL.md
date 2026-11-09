---
name: api-client-ts
description: packages/api-client-ts — el yazımı, tipli TS API istemcisini sözleşme (OpenAPI) değişince güncelleme ve web tüketicilerini eşitleme akışı. openapi.yaml değiştiğinde veya web'in yeni bir API çağrısına ihtiyacı olduğunda kullan.
---
# TS API istemcisi (packages/api-client-ts)

## Ne zaman
`packages/contracts/openapi.yaml` değiştiğinde ya da `apps/web` yeni bir uç çağıracağı zaman. İstemci **el yazımıdır**, kod üretilmez; kaynak gerçek sözleşmedir. (MasterFabric `masterfabric-api-ts` pratiğinden uyarlanmıştır.)

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Paket adı | `@tuik-ai-starter/api-client` (`main: src/index.ts`) |
| Dosyalar | `src/types.ts` (tipler), `src/index.ts` (istemci), `src/client.test.ts` |
| Taşıyıcı | `Transport` enjekte edilir; varsayılan `fetch`; testte sahte taşıyıcı |
| Hata | `status >= 400` → `ApiError(status, code, message)`; gövde `{error:{code,message}}` |
| Taban URL | çağıran verir (`createClient(baseUrl)`); koda gömme |
| Test | `cd packages/api-client-ts && npm install && npm test` (Vitest) |
| Şema → tip | camelCase'e çevirme; **sözleşmedeki alan adları aynen** (`period`, `region`, `value`) |

Sorma. Sözleşmede olup istemcide olmayan işlem varsa ve şimdi yazmıyorsan `CLIENT_GAPS` içine ekle.

## Gerçek durum (doğrulandı)
`src/index.ts` şu an yalnızca `health()` içerir ve `CLIENT_GAPS = []`. Sözleşmede ise `GET /series/{code}` ve `Series`/`Observation`/`Error` şemaları var → **`getSeries` istemcide eksik** (görünür borç; ya ekle ya `CLIENT_GAPS`'e `"GET /series/{code}"` yaz). `Transport` imzası: `(path, init?) => Promise<{status, json()}>`.

## Adımlar
1. `openapi.yaml` değişikliğini oku: yeni/değişen `paths` ve `components/schemas`.
2. `src/types.ts`: şemaya birebir TS arayüzü ekle (nullable → `| null`, enum → birleşim tipi).
3. `src/index.ts`: `createClient` dönüşüne fonksiyon ekle; yol parametresini `encodeURIComponent` ile kodla.
4. Sözleşmede olup yazmadığın işlemleri `CLIENT_GAPS` dizisine yaz; yazdıklarını diziden çıkar.
5. `src/client.test.ts`: başarılı yol + hata yolu (sahte taşıyıcıyla).
6. `cd packages/api-client-ts && npm test`.
7. `apps/web` tüketicilerini bul (`grep -rn "api-client" apps/web/src`) ve çağrıları/tipleri güncelle; `cd apps/web && npm test`.
8. `CHANGELOG.md`: `- contracts: ...` ve gerekiyorsa `- web: ...`; web görünür değiştiyse `apps/web/package.json` sürümünü artır.
9. Kırıcı sözleşme değişikliğinde (alan silme/yeniden adlandırma) önce API'yi, sonra istemciyi yayına al; PR'da sırayı yaz.

## Şablon

`src/types.ts` eki (sözleşmedeki `Series`):
```ts
export type ObservationStatus = "geçici" | "kesin" | "revize" | "gizli" | "tahmini";
export interface Observation { period: string; region: string; value: number | null; status: ObservationStatus }
export interface Series { code: string; name: string; unit: string; observations: Observation[] }
```

`src/index.ts` — `createClient` dönüşü:
```ts
import type { ApiErrorBody, HealthResponse, Series } from "./types";
// ...
return {
  health: () => call<HealthResponse>("/health"),
  getSeries: (code: string) => call<Series>(`/series/${encodeURIComponent(code)}`),
};
```

Test (`src/client.test.ts` içindeki mevcut `fake` yardımcısıyla):
```ts
it("seriyi döndürür", async () => {
  const body = { code: "ORNEK-ENDEKS", name: "Örnek (sentetik)", unit: "endeks", observations: [] };
  const c = createClient("http://x", fake(200, body));
  expect(await c.getSeries("ORNEK-ENDEKS")).toEqual(body);
});
it("404 ApiError olur", async () => {
  const c = createClient("http://x", fake(404, { error: { code: "not_found", message: "seri bulunamadı" } }));
  await expect(c.getSeries("YOK")).rejects.toMatchObject({ status: 404, code: "not_found" });
});
```

## Örnek
Girdi: sözleşmeye `GET /indicators/{code}` eklendi → `types.ts`'e `Indicator`, `index.ts`'e `getIndicator(code)`, testte 200 ve 404 senaryosu, `CHANGELOG`: `- contracts: /indicators/{code} eklendi`, `- web: ...`.

## Bitti kontrol listesi
- [ ] Tipler sözleşmeyle alan alan eşleşiyor
- [ ] Yeni fonksiyon + başarı ve hata testi
- [ ] `CLIENT_GAPS` güncel (boş değilse sebebi açık)
- [ ] `apps/web` tüketicileri derleniyor ve testleri geçiyor
- [ ] `CHANGELOG.md` `contracts:`/`web:` satırları
- [ ] Taban URL ve sırlar koda gömülmedi

## Sık hatalar
- Sözleşmeyi güncellemeden istemciyi değiştirmek.
- Gizli hücre için `value: number` yazmak (`null` olabilir).
- Hata gövdesini yok sayıp ham `Response` fırlatmak.
- Test için gerçek ağ çağrısı yapmak (taşıyıcıyı enjekte et).
- Yol parametresini kodlamamak.

## İlgili
`/regenerate-client` · `go-api-endpoint` · `nextjs-sayfa-bilesen` · `packages/contracts/openapi.yaml` · `.claude/rules/04-ship-checklist.md`
