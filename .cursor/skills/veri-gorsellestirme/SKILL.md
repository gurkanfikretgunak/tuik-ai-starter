---
name: veri-gorsellestirme
description: Grafik ve dashboard standartları (doğru grafik türü, erişilebilir renk, Türkçe etiket, tablo alternatifi, gizli hücre gösterimi). Çizgi/çubuk grafik, dashboard veya seri görselleştirmesi istendiğinde kullan.
---
# Görselleştirme

## Ne zaman
Seri, dağılım veya karşılaştırma görselleştirilirken (`apps/web`). Veri her zaman `getDataSource()` ile gelir (`veri-adaptoru`); yayımlanacak her grafik önce `ifsa-kontrolu`ndan geçer.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Zaman serisi | çizgi grafik; x = `donem`, y = `deger` |
| Kategori karşılaştırma | yatay/dikey çubuk; sıfırdan başlayan eksen |
| Dağılım | histogram |
| Parça-bütün | yığılmış çubuk (pasta en son çare, ≤ 4 dilim) |
| Kütüphane | **yok kurulu**; varsayılan: bağımlılıksız, erişilebilir SVG bileşeni. Kütüphane (ör. Recharts) gerekiyorsa PR'da gerekçe + `make audit` (doğrulanmadı: kurulu değil) |
| Renk | renk körü dostu Okabe–Ito paleti (aşağıda) |
| Sayı biçimi | `formatNumber` (`@/lib/format`, `tr-TR`) |
| Başlık/alt yazı | başlık + birim + dönem aralığı + kaynak notu |
| Alternatif | grafiğin altında aynı veriyi veren `<table>` |
| Örnek veri | "Örnek veri — gerçek istatistik değildir" notu |

Sorma. Gizli veri/küçük hücre riski varsa dur: `ifsa-kontrolu`.

## Kurallar
1. Eksenler etiketli ve birimli; y ekseni çubukta 0'dan başlar, çizgide gerekçeyle kesilebilir.
2. Seri sayısı ≤ 5; fazlası için küçük çoklu (small multiples) veya süzme.
3. Yalnızca renge bağlı anlam yok: çizgi stili (düz/kesikli) veya doğrudan etiket ekle.
4. `gizli` gözlem (`deger: null`) **çizilmez**, sıfır yapılmaz; çizgide boşluk bırak ve dipnotla "gizli" yaz.
5. `geçici`/`tahmini` gözlemleri farklı stille (kesikli) göster; lejant ekle.
6. SVG'ye `role="img"` + `aria-label`/`<title>`; ayrıntı için tablo.
7. Kontrast ≥ 4.5:1 (metin), ≥ 3:1 (grafik öğeleri).

Okabe–Ito: `#0072B2` `#E69F00` `#009E73` `#CC79A7` `#56B4E9` `#D55E00` `#000000`.

## Adımlar
1. Veriyi adaptörden al; yalnızca gösterilecek seriyi süz.
2. `ifsa-kontrolu` ve gizli hücre kontrolü.
3. Grafik türünü yukarıdaki tablodan seç.
4. Aşağıdaki şablonu `apps/web/src/components/SeriGrafik.tsx` olarak ekle (klasör yoksa oluştur).
5. Altına tablo alternatifini koy; kaynak ve dönem notu yaz.
6. Saf ölçekleme fonksiyonunu test et (`scale.test.ts`); `cd apps/web && npm test`.
7. Yeni görünüm → `package.json` MINOR, `CHANGELOG.md` `web:`.

## Şablon
Bağımlılıksız çizgi grafik (`apps/web/src/components/SeriGrafik.tsx`):
```tsx
import type { Gozlem } from "@/lib/data";
import { formatNumber } from "@/lib/format";

const W = 640, H = 280, PAD = 40;

export function scale(v: number, min: number, max: number, a: number, b: number): number {
  return max === min ? (a + b) / 2 : a + ((v - min) / (max - min)) * (b - a);
}

export function SeriGrafik({ baslik, birim, gozlemler }: { baslik: string; birim: string; gozlemler: Gozlem[] }) {
  const pts = gozlemler.filter((g) => g.deger !== null) as (Gozlem & { deger: number })[]; // gizli çizilmez
  if (pts.length === 0) return <p>Gösterilecek veri yok.</p>;
  const vals = pts.map((g) => g.deger);
  const [min, max] = [Math.min(...vals), Math.max(...vals)];
  const xy = pts.map((g, i) => [scale(i, 0, Math.max(pts.length - 1, 1), PAD, W - PAD), scale(g.deger, min, max, H - PAD, PAD)]);
  return (
    <figure>
      <svg viewBox={`0 0 ${W} ${H}`} role="img" aria-label={`${baslik}, birim: ${birim}`}>
        <title>{baslik}</title>
        <polyline fill="none" stroke="#0072B2" strokeWidth={2} points={xy.map((p) => p.join(",")).join(" ")} />
        <text x={PAD} y={14} fontSize={12}>{birim}</text>
        <text x={PAD} y={H - 8} fontSize={12}>{pts[0].donem}</text>
        <text x={W - PAD} y={H - 8} fontSize={12} textAnchor="end">{pts[pts.length - 1].donem}</text>
        <text x={4} y={PAD} fontSize={12}>{formatNumber(max)}</text>
        <text x={4} y={H - PAD} fontSize={12}>{formatNumber(min)}</text>
      </svg>
      <figcaption>Kaynak: sentetik örnek veri. Gizli hücreler çizilmemiştir.</figcaption>
      <table>
        <caption>{baslik} — tablo görünümü</caption>
        <thead><tr><th scope="col">Dönem</th><th scope="col">Değer ({birim})</th><th scope="col">Durum</th></tr></thead>
        <tbody>
          {gozlemler.map((g) => (
            <tr key={`${g.donem}-${g.bolge}`}>
              <td>{g.donem}</td><td>{g.deger === null ? "gizli" : formatNumber(g.deger)}</td><td>{g.durum}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </figure>
  );
}
```
Not: bir bölge seçilmeden birden çok bölgeyi tek çizgiye karıştırma; çağıran önce `gozlemler.filter((g) => g.bolge === "A")` yapar.

Test (`apps/web/src/components/scale.test.ts`):
```ts
import { describe, expect, it } from "vitest";
import { scale } from "./SeriGrafik";
describe("scale", () => {
  it("uç değerleri aralığa eşler", () => {
    expect(scale(0, 0, 10, 40, 600)).toBe(40);
    expect(scale(10, 0, 10, 40, 600)).toBe(600);
  });
  it("sabit seride orta noktayı döndürür", () => expect(scale(5, 5, 5, 0, 100)).toBe(50));
});
```

## Örnek
Girdi: `ORNEK-ENDEKS`, bölge A → noktalar 100,0 / 102,5 / 101,2 (2024-01..03). Çıktı: tek çizgili grafik, y etiketleri `102,5` ve `100,0`, altında 3 satırlık tablo. Bölge B'nin `2024-03` hücresi `gizli`: çizilmez, tabloda "gizli".

## Bitti kontrol listesi
- [ ] Doğru grafik türü; ≤ 5 seri
- [ ] Eksen etiketi, birim, dönem, kaynak notu
- [ ] Renk körü dostu palet; anlam yalnızca renge bağlı değil
- [ ] `role="img"` + ad; tablo alternatifi var
- [ ] Gizli hücre çizilmiyor, 0 yapılmıyor
- [ ] Sayılar `tr-TR`
- [ ] İfşa kontrolü yapıldı; örnek veri notu var

## Sık hatalar
- Gizli hücreyi 0 çizmek (düşüş gibi görünür).
- Çubuk grafikte kesik y ekseni.
- Kırmızı/yeşil ayrımına dayanmak; tablo koymamak.
- Farklı bölgeleri tek çizgiye birleştirmek.
- Yeni grafik kütüphanesini denetimsiz eklemek.
- Pasta grafikle çok dilimli karşılaştırma.

## İlgili
`nextjs-sayfa-bilesen` · `veri-adaptoru` · `ifsa-kontrolu` · `tasarim-dokumani` · `kalite-raporu`
