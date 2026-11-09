# Tasarım özeti — <proje adı>

Bu şablonu `DESIGN.md` olarak proje köküne kopyalayın ve doldurun (`.claude/skills/tasarim-dokumani`). Boş bırakılan alanı model uydurmasın diye "karar verilmedi" yazın.

Tema: açık/koyu · Dil: TR (+EN?) · Erişilebilirlik hedefi: WCAG 2.2 AA

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| Tema | Açık + koyu, sistem tercihini izler |
| Dil | TR zorunlu; EN yalnız proje isterse |
| Sayı biçimi | `tr-TR` (`apps/web/src/lib/format.ts` içindeki `formatNumber`) |
| Grafik | Çizgi (zaman serisi), tablo alternatifi her zaman |
| Veri | Sentetikse "örnek veri" uyarısı görünür |

## Referanslar ve alınan desenler
| Referans | URL | Alınan desen |
|---|---|---|
| <ad> | <URL> | <ör. arama kutusunda sonuç sayısı> |

## Renk ve tipografi
- Zemin / kart / vurgu / metin token'ları: `--bg`, `--card`, `--accent`, `--text` (değerleri yazın; kontrast ≥ 4.5:1)
- Başlık, etiket, değer stilleri: <boyut/ağırlık>
- Sayısal kimlikler: `font-mono tabular-nums`
- Renk tek başına anlam taşımaz (şekil/etiket ekle)

## Bileşenler
- Arama kutusu (sonuç sayısı, süre, klavye ipuçları; Türkçe karakter duyarsız: `foldTr`), liste satırı, kimlik çipleri, durum rozetleri
- İstatistik bileşenleri: seri grafiği, tablo (birim, dönem, kaynak), `geçici/kesin` etiketi, `gizli` hücre
- Gizli hücre: değer yerine "gizli" etiketi (`status: gizli`, `value: null`); asla sayı gösterme

## Durumlar
Boş · Yükleniyor · Hata · Örnek veri uyarısı. Her biri için metin (TR) yazın.

## Erişilebilirlik kontrol listesi
- [ ] Kontrast · [ ] Klavye gezinmesi · [ ] Etiketler/alt metin · [ ] Tablo alternatifi
- [ ] Odak göstergesi görünür · [ ] Ekran okuyucu için grafik özeti · [ ] `prefers-reduced-motion` saygı

## Örnek (doldurulmuş satır)
`Aksan rengi: --accent #1F5FBF (zemin #FFFFFF üzerinde kontrast ~6:1; doğrulanmadı, araçla ölç).`

## Sık hatalar
- Yalnız renkle durum göstermek · ondalık ayırıcıyı noktayla yazmak · grafiğe tablo alternatifi koymamak.
