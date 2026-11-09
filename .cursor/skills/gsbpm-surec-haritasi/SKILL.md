---
name: gsbpm-surec-haritasi
description: Bir işi istatistik üretim sürecinin (GSBPM) aşamalarına eşler; her aşama için çıktı, kontrol, skill ve repo yolu önerir. Yeni istatistik/gösterge/anket projesi planlanırken veya "bu iş sürecin neresinde" sorulduğunda kullan.
---
# GSBPM süreç haritası

Amaç: verilen işi 8 aşamaya eşle, her aşama için **çıktı + kontrol + skill + repo yolu** tablosunu soru sormadan doldur. Kurum kendi süreç modelini verdiyse o esas alınır (GSBPM ortak referanstır).

## Ne zaman
- Yeni gösterge/anket/seri projesi planlanırken (`/new-surec`).
- "Bu iş sürecin neresinde?", "sırada ne var?" soruları.
- PR'ın hangi aşamaya ait olduğunu ve eksik kontrolü bulmak için.

## Girdiler ve varsayılanlar
| Girdi | Eksikse varsayım |
|---|---|
| İş tanımı | Kullanıcının cümlesi; tek cümleye indir |
| Periyot | aylık (`2026-03` biçimi) |
| Veri | sentetik (`data/sample/`); gerçek veri kullanılmaz |
| Yayım kanalı | API (`/series/{code}`) + web tablosu |
| Hangi aşamalar | 1–8 hepsi; ilgisiz olanı "kapsam dışı" yaz |
| Sorumlu | boş bırak, `<SORUMLU>` yaz |
Yalnızca kritik belirsizlikte sor: iş gerçek mikro veri gerektiriyorsa dur ve uyar (`.claude/rules/01-veri-gizliligi.md`).

## Aşamalar (referans)
| # | Aşama | Çıktı | Kontrol | Skill / araç | Repo yolu |
|---|---|---|---|---|---|
| 1 | İhtiyaç belirleme | PRD, gösterge listesi | kapsam netliği | `proje-baslat` | `docs/` |
| 2 | Tasarım | gösterge tanımı, sınıflama, örneklem, metaveri | tanım tutarlılığı | `istatistik-gostergesi`, `siniflandirma-esleme` | `packages/contracts/` |
| 3 | Yapılandırma | boru hattı, modül, endpoint + test | `make test` yeşil | `py-hesaplama-modulu`, `go-api-endpoint` | `compute/`, `services/api/` |
| 4 | Veri toplama | ham veri (değişmez), adaptör | şema doğrulama | `veri-adaptoru` | `data/sample/` |
| 5 | İşleme | işlenmiş veri, düzeltme günlüğü | `check_*` kuralları | `veri-temizleme`, `agirliklandirma-ornekleme` | `compute/src/tuik_calc/validation.py`, `weights.py` |
| 6 | Analiz | tahmin, endeks, tablo | bağımsız yeniden hesap | `endeks-hesaplama`, `kalite-raporu` | `compute/src/tuik_calc/indices.py` |
| 7 | Yayım | tablo/grafik/API, takvim | ifşa + embargo + durum | `ifsa-kontrolu`, `yayin-ve-revizyon`, `veri-gorsellestirme` | `disclosure.py`, `openapi.yaml` |
| 8 | Değerlendirme | kalite raporu, geri bildirim | kalite ölçütleri | `kalite-raporu` | `.claude/skills/kalite-raporu/sablon.md` |

## Adımlar
1. İşi tek cümleyle yaz; periyot, birim, kapsamı varsayılanlarla doldur.
2. Yukarıdaki tabloyu kopyala; "Bu işte ne yapılıyor" sütununu ekle; ilgisiz aşamaya `kapsam dışı` yaz.
3. İlk eksik aşamayı bul (genelde 2 veya 5); oradan başla.
4. Her aşama için çalıştırılacak komutu yaz (`make test`, `make lint`, `/ifsa-kontrol`, `/kalite-kontrol`).
5. Aşama sırasını koru: **doğrulama → ifşa kontrolü → kalite raporu → yayım bayrağı** (`12-yayin-ve-revizyon` kuralı).
6. Haritayı PR açıklamasına veya `docs/` altına koy; kod yazmaya sonra geç ("önce plan").

## Şablon
```
## Süreç haritası: <gösterge> (<periyot>)
| Aşama | Bu işte ne yapılıyor | Çıktı | Kontrol | Skill | Durum |
|---|---|---|---|---|---|
| 2 Tasarım | <...> | <...> | <...> | istatistik-gostergesi | yapılacak |
Sıradaki adım: <tek cümle>   Riskler: <veri gizliliği / ifşa / seri kırılması>
```

## Örnek
Girdi: "Aylık sanayi üretim endeksi için API ve tablo yapacağız."
Çıktı (özet): 2 Tasarım → gösterge `IUE_M`, birim endeks (2015=100), aylık · 5 İşleme → `check_range`, `check_required` · 6 Analiz → `chain_index`, `percent_change` · 7 Yayım → `suppress_row`, `durum` alanı, takvim · 8 → kalite raporu. Aşama 1 ve 4 "kapsam dışı: sentetik veri".

## Bitti kontrol listesi
- [ ] 8 aşamanın hepsi ya dolu ya "kapsam dışı + gerekçe".
- [ ] Her dolu aşamada çıktı, kontrol ve skill adı var.
- [ ] Gerçek veri gerektiren adım varsa uyarı yazıldı.
- [ ] Sıradaki tek adım belli.

## Sık hatalar
- Aşama 7'yi (ifşa, embargo) atlayıp yayım planlamak.
- Kalite raporunu "sonra" bırakmak; ölçütler 5–6. aşamada toplanır.
- Kurumsal eşikleri haritaya sayı olarak gömmek (parametre; kurum kararı).
- Aşama numarasını dosya yoluyla karıştırmak; yolu tablodan al.

## İlgili
`.claude/rules/08-istatistik-surec.md` · `.claude/commands/new-surec.md` · `docs/egitim/07-istatistik-surec-akisi.md` · diğer skill'ler: tablodaki adlar.
