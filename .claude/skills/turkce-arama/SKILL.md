---
name: turkce-arama
description: Türkçe karakter duyarsız arama, süzme ve eşleşen kısmı vurgulama (İ/ı/I/i, Ş, Ğ, Ü, Ö, Ç). İl, faaliyet, gösterge adı gibi alanlarda arama yapılan her yerde kullan.
---
# Türkçe arama (apps/web/src/lib/tr-search.ts)

## Ne zaman
Kullanıcı metin yazıp il, faaliyet, gösterge adı vb. aradığında veya süzdüğünde. `toLowerCase()`/`localeCompare` ile kendi çözümünü yazma.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Kütüphane | `apps/web/src/lib/tr-search.ts` (`foldTr`, `matchesTr`, `highlightTr`, tip `Segment`) |
| Eşleşme | katlanmış metinde **alt dize** (`includes`) |
| Boş sorgu | her şeyi eşler |
| Vurgu | yalnızca **ilk** eşleşme; `<mark>` ile |
| Büyük liste | sunucu tarafında indeks; indeks de `foldTr` ile katlanır |
| Bağımlılık | yeni arama kütüphanesi ekleme (MiniSearch gerekirse PR'da gerekçe, `make audit`) |

Sorma.

## Katlama tablosu (koddan)
`İ I ı i → i` · `Ş ş → s` · `Ğ ğ → g` · `Ü ü → u` · `Ö ö → o` · `Ç ç → c`; diğer tek karakterler `toLowerCase()`. **Karakter sayısı korunur** (1:1), bu yüzden `highlightTr` indeksleri özgün metinde de geçerlidir.

## Adımlar
1. Süzme: `items.filter((x) => matchesTr(x.ad, q))`.
2. Vurgu: `highlightTr(text, q)` → `Segment[]`; `match` olan parçayı `<mark>` ile göster.
3. Birden çok alan: `matchesTr(`${x.ad} ${x.kod}`, q)` veya alanlardan herhangi biri.
4. Sonuç sayısını `aria-live="polite"` ile duyur; boş sonuçta "Sonuç bulunamadı" göster.
5. Yeni katlama gereksinimi (ör. `â`, `î`) olursa `MAP`'e **1:1** ekle ve test yaz; çok karakterli eşleme yapma.
6. Test: `apps/web/src/lib/tr-search.test.ts` içine ekle; `cd apps/web && npm test`.

## Şablon
Süzme + vurgu (istemci bileşeni, `"use client"`):
```tsx
"use client";
import { useState } from "react";
import { highlightTr, matchesTr } from "@/lib/tr-search";

export function IlArama({ iller }: { iller: string[] }) {
  const [q, setQ] = useState("");
  const sonuc = iller.filter((il) => matchesTr(il, q));
  return (
    <div>
      <label htmlFor="il-ara">İl ara</label>
      <input id="il-ara" type="search" value={q} onChange={(e) => setQ(e.target.value)} />
      <p aria-live="polite">{sonuc.length} sonuç</p>
      <ul>
        {sonuc.map((il) => (
          <li key={il}>
            {highlightTr(il, q).map((s, i) => (s.match ? <mark key={i}>{s.text}</mark> : <span key={i}>{s.text}</span>))}
          </li>
        ))}
      </ul>
    </div>
  );
}
```
Yeni test:
```ts
it("büyük İ ve noktasız ı eşleşir", () => {
  expect(matchesTr("Iğdır", "igdir")).toBe(true);
  expect(matchesTr("İzmir", "IZMIR")).toBe(true);
});
```

## Örnek (sentetik girdi → çıktı)
| Çağrı | Sonuç |
|---|---|
| `foldTr("İSTANBUL")` | `"istanbul"` |
| `foldTr("ığdır")` | `"igdir"` |
| `matchesTr("Çankırı", "cankiri")` | `true` |
| `matchesTr("Çankırı", "ankara")` | `false` |
| `highlightTr("Doğu Anadolu", "dogu")` | `[{text:"Doğu",match:true},{text:" Anadolu",match:false}]` |

## Bitti kontrol listesi
- [ ] Süzme `matchesTr`, vurgu `highlightTr` ile
- [ ] `dangerouslySetInnerHTML` yok
- [ ] Sonuç sayısı duyuruluyor; boş durum mesajı var
- [ ] Testler İ/ı/I/i ve aksansız sorguyu kapsıyor
- [ ] Katlama eklendiyse uzunluk korunuyor (test var)

## Sık hatalar
- `toLowerCase()` ile karşılaştırmak: `"İ".toLowerCase()` iki karakterli (`i̇`) olur, indeksler kayar.
- Katlanmış metni ekranda göstermek (özgün metni göster, katlanmışı yalnızca eşleştirmede kullan).
- Vurguyu HTML dizgesi olarak üretmek (XSS riski).
- Sunucu indeksini farklı, istemciyi farklı katlama ile yapmak.
- Boş sorguda sonuç listesini boşaltmak.

## İlgili
`nextjs-sayfa-bilesen` · `veri-adaptoru` · `siniflandirma-esleme` · `apps/web/src/lib/tr-search.test.ts`
