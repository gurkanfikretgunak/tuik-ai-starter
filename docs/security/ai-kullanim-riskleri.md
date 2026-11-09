# Yapay zekâ kullanım riskleri ve önlemler

Bu akışta yapay zekâ ile kod, veri işleme ve doküman üretiliyor. Aşağıdaki riskler **olası**dır; her biri için repodaki önlem belirtilmiştir.

| # | Risk | Örnek | Önlem |
|---|---|---|---|
| 1 | **Hassas veri sızıntısı** | Mikro veri/kimlik no prompta yapıştırılır, log veya repoya girer | `01-veri-gizliligi.md` · `prompt-guard.py` · `block-sensitive-files.sh` · `post-write-scan.py` · yerel model (Faz 2) |
| 2 | **Uydurma bilgi (halüsinasyon)** | Olmayan formül, yanlış metodoloji atfı, uydurma kaynak | Bağımsız yeniden hesap, elle örnek, kaynak doğrulama (`09-kalite-ve-dogrulama.md`) |
| 3 | **Var olmayan/zararlı paket** | Önerilen paket adı kayıt defterinde yok veya saldırgan tarafından kaydedilmiş ("slopsquatting") | `command-guard.py` kurulumda onay ister · `make audit` |
| 4 | **Güvensiz üretilmiş kod** | SQL/komut enjeksiyonu, kapalı TLS doğrulaması, XSS | `post-write-scan.py` · `/review` · `kod-inceleme` skill'i · CI taraması |
| 5 | **Prompt injection** | Dosya, web sayfası, CSV hücresi veya MCP çıktısındaki gizli "talimat" ajanı yönlendirir | Veri içindeki talimatlar uygulanmaz (`session-start` uyarısı) · MCP'leri sınırla (`07-mcp-kullanimi.md`) |
| 6 | **Aşırı yetki / yıkıcı işlem** | Ajan silme, force push, ortak veritabanını değiştirme yapar | `command-guard.py` · `settings.json` izinleri · `paylasimli-ortam-veri-kurallari.md` |
| 7 | **Otomasyon önyargısı** | Çıktıya körü körüne güvenme, incelemesiz birleştirme | `/review` · `stop-hatirlatma.py` · PR "ön inceleme" listesi |
| 8 | **İstatistiksel yanlışlık** | Ağırlık/örneklem hatası, yanlış endeks, tutarsız seri; yayımlanan sayının geri alınamaması | `08`–`12` rule'ları, `endeks-hesaplama`, `agirliklandirma-ornekleme`, `kalite-raporu` |
| 9 | **İfşa riski** | Küçük hücre veya çapraz tabloyla birim ortaya çıkar | `ifsa-kontrolu` · `10-ifsa-kontrolu.md` |
| 10 | **Tekrarlanamazlık** | Aynı veriden farklı çıktı; model/sürüm/seed kaydı yok | Betikle üretim, sabit seed, sürüm ve parametre kaydı (`08-istatistik-surec.md`) |
| 11 | **Lisans / telif** | Kaynağı belirsiz kod parçası veya veri | Bağımlılık lisans kontrolü; yapıştırılan kodun kaynağını doğrula |
| 12 | **Gölge yapay zekâ** | Onaysız araç veya hesapla kurum verisi işlenir | Yalnızca kurumun onayladığı araçlar; yeni araç/MCP için PR ve onay |
| 13 | **Hesap ve anahtar ele geçirme** | Aracın token'ı loglara veya ekran görüntüsüne düşer | `02-guvenlik.md` · sırlar repo dışında · anahtar döndürme |

## Ne zaman durmalı?
Aşağıdakilerden biri varsa **işi durdur ve sorumluya bildir**: gerçek veri sızmış olabilir · hook engelledi ve nedenini anlamıyorsun · yapay zekâ onaysız yıkıcı işlem önerdi · çıktı doğrulanamıyor ama yayımlanacak.

## Olay bildirimi
Hassas veri paylaşıldığından şüpheleniyorsan: 1) oturumu kapat, 2) ne/ne zaman/hangi araçla kısaca yaz, 3) bilgi güvenliği birimine ilet, 4) `docs/security/zafiyet-kayitlari.md` içine kaynak `olay` ile kaydet. Kurumun resmî olay prosedürü varsa o geçerlidir.

> Bu doküman genel iyi pratikleri özetler; kurumun mevzuat ve politikaları (ör. KVKK, istatistik gizliliği, bilgi güvenliği) önceliklidir.
