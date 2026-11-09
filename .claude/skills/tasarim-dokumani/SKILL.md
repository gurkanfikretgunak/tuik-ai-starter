---
name: tasarim-dokumani
description: Arayüz kararlarını DESIGN.md içinde referanslarla belgelendirir (tema, renk, tipografi, bileşen desenleri, erişilebilirlik). Yeni web arayüzü başlatılırken veya tasarım tutarsızlaştığında kullan.
---
# Tasarım dokümanı (DESIGN.md)

## Ne zaman
Yeni web arayüzü başlarken (prompt serisinde 4. adım) veya ekranlar birbirinden saptığında. (Şirket Sicil `DESIGN.md` pratiğinden uyarlanmıştır.)

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Şablon | `docs/tasarim/DESIGN.template.md` |
| Hedef dosya | proje kökünde `DESIGN.md` (monorepo kökünde veya `projects/<ad>/DESIGN.md`) |
| Tema | açık + koyu |
| Dil | TR (EN yalnızca proje isterse) |
| Erişilebilirlik | WCAG 2.2 AA |
| Referanslar | ≥ 3: kamu portalı/tasarım sistemi (ör. GOV.UK Design System) + URL + alınan desen; **URL'yi doğrula, uydurma**; emin değilsen "doğrulanmadı" yaz |
| Sayısal alanlar | `font-variant-numeric: tabular-nums` (Tailwind yoksa CSS) |
| Sayı biçimi | `tr-TR` (`formatNumber`) |

Sorma; şablonu doldur, belirsiz kalemi "Varsayım:" diye işaretle.

## Adımlar
1. `cp docs/tasarim/DESIGN.template.md DESIGN.md` ve `<proje adı>`'nı değiştir.
2. **Referans tablosunu doldur:** her satırda referans, URL, "alınan desen". Kopyalama değil, desen çıkar.
3. **Token'lar:** zemin, kart, vurgu, metin, uyarı, hata (açık ve koyu); aşağıdaki CSS değişkenlerini kullan.
4. **Tipografi:** başlık, gövde, etiket, değer; ölçek (ör. 14/16/20/28 px).
5. **Bileşenler:** arama kutusu, liste satırı, kimlik çipi, durum rozetleri, tablo, grafik (`veri-gorsellestirme`).
6. **İstatistik kuralları:** kaynak ve dönem notu, birim, `geçici/kesin/revize/tahmini` rozeti, `gizli` hücre gösterimi ("gizli", gri), örnek veri uyarısı.
7. **Durumlar:** boş, yükleniyor, hata (`loading.tsx`/`error.tsx`).
8. **Erişilebilirlik listesi:** kontrast, klavye, etiket/alt metin, tablo alternatifi.
9. Yeni ekran bu belgeye uyar; sapma gerekiyorsa **önce belgeyi güncelle**, sonra kodu.

## Şablon
CSS token'ları (`apps/web/src/app/globals.css`, `layout.tsx`'ten içe aktarılır):
```css
:root {
  --bg: #ffffff; --surface: #f6f7f9; --text: #1b1f24; --muted: #5a6572;
  --accent: #0b5cad; --warn: #8a5a00; --danger: #b3261e; --border: #d5dae1;
}
@media (prefers-color-scheme: dark) {
  :root { --bg: #11151a; --surface: #1a2027; --text: #e8ecf1; --muted: #9aa6b4;
    --accent: #6cb2ff; --warn: #e0b04a; --danger: #ff8a80; --border: #2c353f; }
}
.num { font-variant-numeric: tabular-nums; text-align: right; }
.badge { padding: 0 .5rem; border-radius: .75rem; border: 1px solid var(--border); font-size: .85rem; }
.badge--gecici { color: var(--warn); }
.cell--gizli { color: var(--muted); font-style: italic; }
```
Referans tablosu satırı (örnek biçim; URL'yi kullanmadan önce doğrula):
```
| GOV.UK Design System | https://design-system.service.gov.uk | tablo, hata özeti, tarih girişi desenleri |
```

## Örnek
Girdi: "Gösterge arama uygulaması için tasarım dokümanı" → `DESIGN.md`: 3 referans, token tablosu, durum rozeti eşlemesi (`kesin` nötr, `geçici` uyarı rengi + metin, `gizli` gri italik), arama kutusu için `aria-live` sonuç sayısı, erişilebilirlik kutuları işaretli.

## Bitti kontrol listesi
- [ ] `DESIGN.md` kökte; şablon başlıkları dolu
- [ ] ≥ 3 referans + URL + alınan desen (doğrulanmış)
- [ ] Açık/koyu token'lar; kontrast ölçüldü
- [ ] Durumlar ve istatistik rozetleri tanımlı
- [ ] Erişilebilirlik listesi işaretli
- [ ] Mevcut ekranlar belgeyle uyumlu

## Sık hatalar
- Referans URL uydurmak veya desen yerine arayüzü kopyalamak.
- Yalnızca renkle durum belirtmek (rozette metin de olmalı).
- Belgeyi güncellemeden kodda sapmak.
- Token yerine sabit hex dağıtmak.

## İlgili
`nextjs-sayfa-bilesen` · `veri-gorsellestirme` · `prompt-serisi` · `docs/tasarim/DESIGN.template.md`
