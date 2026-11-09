---
name: nextjs-sayfa-bilesen
description: Next.js App Router'da sayfa veya bileşen oluşturur (TypeScript, erişilebilir, Türkçe arayüz, tr-TR biçimleri, veri adaptörü). apps/web altında yeni ekran, liste, tablo, arama kutusu veya bileşen istendiğinde kullan.
---
# Next.js sayfa/bileşen (apps/web)

## Ne zaman
`apps/web/src/` altında yeni sayfa, bileşen, form veya liste yazılırken. Veri her zaman adaptörden gelir (`veri-adaptoru`), arama `turkce-arama` ile yapılır, grafik `veri-gorsellestirme` ile.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Yönlendirici | App Router, `apps/web/src/app/<yol>/page.tsx` |
| Bileşen türü | sunucu bileşeni; etkileşim varsa küçük `"use client"` bileşeni |
| Veri | `getDataSource()` (`@/lib/data`), kaynak `DATA_SOURCE`, varsayılan `sample` |
| Dil | `lang="tr"` (kök `layout.tsx`); tüm görünür metin Türkçe |
| Sayı biçimi | `formatNumber` (`@/lib/format`, `tr-TR`, varsayılan 1 ondalık) |
| Arama | `matchesTr` / `highlightTr` (`@/lib/tr-search`) |
| Alias | `@/*` → `src/*` (`tsconfig.json`) |
| Stil | düz CSS/inline; yeni UI kütüphanesi **ekleme** |
| Örnek veri | sayfada "Örnek veri — gerçek istatistik değildir" notu |

Sorma; varsay ve yaz. Yalnızca sayfa **gizli/mikro veri** gösterecekse dur (`kvkk-kontrol`, `ifsa-kontrolu`).

## Gerçek durum (doğrulandı)
- Mevcut: `src/app/layout.tsx`, `src/app/page.tsx`, `src/lib/{format,tr-search}.ts`, `src/lib/data/{types,index,sample-source}.ts`.
- Test aracı: yalnızca `vitest` (`npm test`). `@testing-library/react` ve `jsdom` **kurulu değil**. Bileşen render testi isteniyorsa önce bağımlılığı PR'da gerekçelendirerek ekle (`make audit`); aksi halde mantığı saf fonksiyona çıkar ve onu test et.
- Web sürümü `apps/web/package.json` içindeki `version` alanıdır (`05-surumleme.md`); alan yoksa ilk görünür değişiklikte ekle. Yeni sayfa = **MINOR**.

## Adımlar
1. Tür/sözleşme: API verisi `packages/contracts/openapi.yaml` ile uyumlu olmalı; yoksa önce sözleşmeyi güncelle (`go-api-endpoint`, `api-client-ts`).
2. Sayfayı yaz: `apps/web/src/app/<yol>/page.tsx` (sunucu bileşeni, `async`).
3. Etkileşimi ayır: `apps/web/src/app/<yol>/<Ad>.tsx` içinde `"use client"` (arama kutusu, filtre).
4. Durumlar: `loading.tsx` (yükleniyor), `error.tsx` (hata; `"use client"` gerekir), boş durum mesajı.
5. Erişilebilirlik: tek `h1`, sıralı başlıklar, `label`/`htmlFor`, `<table>` + `<caption>` + `<th scope>`, klavye ile erişim, `<mark>` ile vurgu.
6. Sayılar `formatNumber`; gizli hücre `null` → "gizli" yazısı (0 yazma); `geçici/kesin` etiketi göster.
7. Metinler: TR zorunlu; proje EN istiyorsa EN ekle.
8. Test: saf mantık için `*.test.ts` (Vitest); en az bir başarılı yol ve bir hata/boş yolu.
9. Çalıştır: `cd apps/web && npm install && npm test && npm run build`.
10. Ship: `package.json` sürümü artır, `CHANGELOG.md` → `- web: <açıklama>`.

## Şablon

Sunucu sayfası (`apps/web/src/app/seri/[kod]/page.tsx`):
```tsx
import { notFound } from "next/navigation";
import { getDataSource } from "@/lib/data";
import { formatNumber } from "@/lib/format";

export default async function SeriSayfasi({ params }: { params: Promise<{ kod: string }> }) {
  const { kod } = await params; // Next 15: params asenkron
  const seri = await getDataSource().getByKod(decodeURIComponent(kod));
  if (!seri) notFound();
  return (
    <main>
      <h1>{seri.ad}</h1>
      <p>Birim: {seri.birim} · Periyot: {seri.periyot} · Kaynak: {seri.kaynak}</p>
      <p role="note">Örnek veri — gerçek istatistik değildir.</p>
      <table>
        <caption>{seri.ad} gözlemleri</caption>
        <thead>
          <tr><th scope="col">Dönem</th><th scope="col">Bölge</th><th scope="col">Değer</th><th scope="col">Durum</th></tr>
        </thead>
        <tbody>
          {seri.gozlemler.map((g) => (
            <tr key={`${g.donem}-${g.bolge}`}>
              <td>{g.donem}</td>
              <td>{g.bolge}</td>
              <td style={{ fontVariantNumeric: "tabular-nums" }}>{g.deger === null ? "gizli" : formatNumber(g.deger)}</td>
              <td>{g.durum}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </main>
  );
}
```

İstemci bileşeni (arama kutusu, `apps/web/src/app/seri/SeriArama.tsx`):
```tsx
"use client";
import { useState } from "react";
import { highlightTr, matchesTr } from "@/lib/tr-search";

export function SeriArama({ adlar }: { adlar: string[] }) {
  const [q, setQ] = useState("");
  const sonuc = adlar.filter((a) => matchesTr(a, q));
  return (
    <section aria-labelledby="ara-baslik">
      <h2 id="ara-baslik">Gösterge ara</h2>
      <label htmlFor="ara">Arama</label>
      <input id="ara" type="search" value={q} onChange={(e) => setQ(e.target.value)} />
      <p aria-live="polite">{sonuc.length} sonuç</p>
      <ul>
        {sonuc.map((a) => (
          <li key={a}>
            {highlightTr(a, q).map((s, i) => (s.match ? <mark key={i}>{s.text}</mark> : <span key={i}>{s.text}</span>))}
          </li>
        ))}
      </ul>
    </section>
  );
}
```

`loading.tsx` / `error.tsx`:
```tsx
export default function Loading() { return <p role="status">Yükleniyor…</p>; }
```
```tsx
"use client";
export default function Error({ reset }: { error: Error; reset: () => void }) {
  return (<div role="alert"><p>Veri yüklenemedi.</p><button onClick={reset}>Tekrar dene</button></div>);
}
```

Saf mantık testi (`apps/web/src/lib/<ad>.test.ts`, Vitest):
```ts
import { describe, expect, it } from "vitest";
import { matchesTr } from "./tr-search";
describe("arama süzgeci", () => {
  it("aksansız sorgu bulur", () => expect(matchesTr("Çankırı", "cankiri")).toBe(true));
  it("eşleşmeyen sorgu elenir", () => expect(matchesTr("Çankırı", "ankara")).toBe(false));
});
```

## Örnek
Girdi: "ORNEK-ENDEKS serisini tablo olarak göster." → `/seri/ORNEK-ENDEKS` sayfası; çıktı: `2024-01 · A · 100,0 · kesin`, `2024-03 · B · gizli · gizli`.

## Bitti kontrol listesi
- [ ] Sayfa `page.tsx`; etkileşim yalnızca gereken yerde `"use client"`
- [ ] `loading`/`error`/boş durum var
- [ ] Tek `h1`, etiketler, `caption`, klavye ile kullanılabilir
- [ ] Sayılar `tr-TR`; gizli hücre "gizli"; örnek veri notu var
- [ ] `dangerouslySetInnerHTML` yok
- [ ] `npm test` ve `npm run build` temiz
- [ ] `package.json` sürümü ve `CHANGELOG.md` (`web:`) güncel

## Sık hatalar
- `toLowerCase()` ile arama (Türkçe `İ`/`ı` bozulur) → `foldTr`.
- `toFixed` veya elle nokta/virgül → `formatNumber`.
- Sunucu bileşeninde `useState`/olay işleyicisi kullanmak.
- Next 15'te `params`'ı `await` etmemek.
- Gizli hücreyi 0 veya boş göstermek; yalnızca renkle anlam vermek.
- Testing Library var sanıp import etmek (kurulu değil).

## İlgili
`/new-page` · `veri-adaptoru` · `turkce-arama` · `veri-gorsellestirme` · `tasarim-dokumani` · `api-client-ts` · `.claude/rules/05-surumleme.md`
