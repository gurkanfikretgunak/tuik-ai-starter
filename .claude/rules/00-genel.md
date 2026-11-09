# Genel kurallar
- Kod, değişken ve commit tipi İngilizce; açıklama, doküman ve arayüz metni Türkçe.
- Commit: `tip(kapsam): açıklama` (feat, fix, docs, test, refactor, chore).
- Küçük, tek amaçlı PR'lar. PR açıklamasında: ne, neden, nasıl test edildi.
- Belirsizlik varsa varsayım yapıp yazıya dök; kritik belirsizlikte önce sor.
- Gereksiz bağımlılık ekleme; eklersen nedenini PR'da belirt.

## Varsayılanlar (sorma, varsay ve yaz)
| Eksik bilgi | Varsayım |
|---|---|
| Dil | Kod/değişken/commit tipi EN; açıklama, doküman, arayüz TR |
| Veri | Yalnızca `data/sample/` (sentetik) |
| Test | Başarılı yol + hata yolu testi yaz |
| Kapsam | Tek amaçlı, en küçük dilim |
| Commit türü | Tür 1: `tip(kapsam): özet` |
Yalnızca şu durumda **sor**: gerçek veri gerekiyorsa, silme/geri alınamaz işlem varsa, sözleşme geriye uyumsuz değişecekse.

## Evet / Hayır
| Durum | Doğru | Yanlış |
|---|---|---|
| Belirsiz istek | Varsayımı PR/yanıta yaz | Sessizce tahmin et |
| Yeni bağımlılık | Gerekçeyi PR'a yaz | Habersiz ekle |
| Büyük iş | `/new-feature` ile plan → kod → test | Plansız toplu değişiklik |
| Kurum eşiği | Parametre/yapılandırma | Koda sabit göm |
| Çıktı | "Doğrulanmadı" diye işaretle | Kanıtsız kesin konuş |

## Do / Don't
- DO: `feat(web): seri sayfası eklendi` · DON'T: `update stuff`, İngilizce açıklama, birden çok konu.
- DO: yetkin olmadığın alanda varsayımını açıkça yaz. DON'T: uydurma yol, komut veya paket adı yaz.
- DO: işi bitirmeden `make lint` + `make test`. DON'T: testi atlayıp "bitti" deme.
- Komutlar: `make dev`, `make test`, `make lint`, `make doctor`, `make audit`, `make test-hooks`, `make sync-cursor`.
