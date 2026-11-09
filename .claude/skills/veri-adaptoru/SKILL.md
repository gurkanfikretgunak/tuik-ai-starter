---
name: veri-adaptoru
description: Uygulamayı veri kaynağından soyutlayan adaptör deseni ve deterministik sentetik veri üreticisi. Örnek veriyle başlayıp sonra gerçek kaynağa (API, dosya, veritabanı) geçilecek her projede kullan.
---
# Veri adaptörü + sentetik veri

## Ne zaman
Bir ekran/hesap veriye ihtiyaç duyduğunda: önce adaptör arayüzü ve sentetik kaynak; gerçek kaynak sonra **yalnızca yeni bir uygulama** olarak bağlanır. (Şirket Sicil örnek projesinden uyarlanmıştır.)

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Arayüz | `SeriDataSource` (`getAll`, `getByKod`) — `apps/web/src/lib/data/types.ts` |
| Kaynak seçimi | `getDataSource()` — `apps/web/src/lib/data/index.ts`; ortam değişkeni `DATA_SOURCE`, varsayılan `sample` |
| Örnek kaynak | `apps/web/src/lib/data/sample-source.ts` (SENTETİK) |
| Üretici | `node scripts/generate-sample-data.mjs [seed]`, varsayılan seed `42`, çıktı `data/sample/sentetik-seri.json` |
| Gizli hücre | `deger: null` + `durum: "gizli"`; asla 0 |
| Durumlar | `geçici`, `kesin`, `revize`, `gizli`, `tahmini` |
| Periyot | `aylık`, `çeyreklik`, `yıllık` |

Sorma. Gerçek veri kaynağı istenirse: önce `kvkk-kontrol` ve `.claude/rules/01-veri-gizliligi.md`; gizli veri bulut modeline gitmez.

## Gerçek yapı (doğrulandı)
```ts
export interface Gozlem { donem: string; bolge: string; deger: number | null; durum: Durum }
export interface Seri { kod; ad; birim; periyot; kaynak; gozlemler: Gozlem[] }
export interface SeriDataSource { getAll(): Promise<Seri[]>; getByKod(kod: string): Promise<Seri | null> }
```
`getDataSource(kind)` tanımsız türde `Error("Tanımsız veri kaynağı: ...")` fırlatır. Mevcut sentetik seri kodu: `ORNEK-ENDEKS`. Go tarafında karşılığı `domain.SeriesRepository` + `infrastructure/memory`.

## Adımlar
1. Arayüzü `types.ts` içinde tanımla/genişlet; bileşenler yalnızca bunu bilir.
2. Sentetik kaynağı `sample-source.ts` içinde uygula; veri açıkça "sentetik" etiketli olsun.
3. `index.ts` içindeki `getDataSource()` tek seçim noktası; yeni kaynak için bir `if (kind === "<ad>") return ...` ekle.
4. Gerçek kaynak: yeni dosya (ör. `api-source.ts`) aynı arayüzü uygular; ağ erişimi `packages/api-client-ts` üzerinden yapılır; adres ortam değişkeninden gelir ve örnek ortam dosyasına yer tutucuyla yazılır (gerçek değer repoya girmez).
5. Üretici betik: `mulberry32(seed)` ile deterministik üret; aynı seed → aynı çıktı (test et: iki çalıştırmayı karşılaştır).
6. Küçük hücre denemesi için üreticideki `birim_sayisi` alanını kullan (`ifsa-kontrolu`).
7. Arayüzde örnek veri notu: "Örnek veri — gerçek istatistik değildir".
8. Test: `apps/web/src/lib/data/data.test.ts` kalıbını kopyala (örnek kaynak seri döner, gizli hücre `null`, bilinmeyen kod `null`, tanımsız kaynak hata verir).
9. `cd apps/web && npm test`.

## Şablon

Yeni kaynak (`apps/web/src/lib/data/api-source.ts`):
```ts
import { createClient } from "@tuik-ai-starter/api-client";
import type { Seri, SeriDataSource } from "./types";

export function createApiSource(baseUrl: string): SeriDataSource {
  const api = createClient(baseUrl);
  return {
    async getAll() { return []; /* sözleşmede liste ucu yoksa önce sözleşmeyi genişlet */ },
    async getByKod(kod): Promise<Seri | null> {
      try {
        const s = await api.getSeries(kod); // api-client-ts'te getSeries eklenmiş olmalı
        return { kod: s.code, ad: s.name, birim: s.unit, periyot: "aylık", kaynak: "API",
          gozlemler: s.observations.map((o) => ({ donem: o.period, bolge: o.region, deger: o.value, durum: o.status })) };
      } catch (e) {
        if ((e as { status?: number }).status === 404) return null;
        throw e;
      }
    },
  };
}
```
`index.ts` bağlama: `if (kind === "api") return createApiSource(<API taban adresi ortam değişkeninden>);`

Sentetik gözlem (üreticiyle uyumlu):
```json
{ "donem": "2024-01", "bolge": "A", "deger": 100.3, "birim_sayisi": 6, "durum": "kesin" }
```

## Örnek
Girdi: `DATA_SOURCE=sample`, `getByKod("ORNEK-ENDEKS")` → 4 gözlem; `2024-03/B` için `deger: null, durum: "gizli"`. `getByKod("YOK")` → `null`. `DATA_SOURCE=gercek` → `Error`. Üretim: `node scripts/generate-sample-data.mjs 7` → "yazıldı: 60 gözlem (seed=7)" (5 bölge × 12 ay).

## Bitti kontrol listesi
- [ ] Bileşenler yalnızca `SeriDataSource` bilir; doğrudan dosya/ağ çağrısı yok
- [ ] Kaynak seçimi tek yerde (`getDataSource`)
- [ ] Gizli hücre `null` + `gizli`; hiçbir yerde 0
- [ ] Üretici deterministik; seed belgelendi
- [ ] Veri sentetik ve etiketli; arayüzde örnek veri notu
- [ ] `data.test.ts` benzeri testler geçiyor

## Sık hatalar
- Bileşenden doğrudan `fetch` veya dosya okuma.
- Gizli hücreyi 0'a çevirmek.
- Sentetik veriyi gerçek kayıttan türetmek.
- `Math.random()` kullanıp tekrarlanamaz veri üretmek.
- Adaptör arayüzünü kaynak başına farklılaştırmak.

## İlgili
`nextjs-sayfa-bilesen` · `api-client-ts` · `ifsa-kontrolu` · `kvkk-kontrol` · `docs/adr/0003-veri-adaptoru-ve-sentetik-veri.md` · `data/sample/README.md`
