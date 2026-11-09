---
name: dokumantasyon
description: README, ADR (mimari karar kaydı) ve API dokümanı üretir; komutlar kopyala-yapıştır çalışır, Türkçe ve sadedir. README, docs/adr, CHANGELOG veya OpenAPI'dan API belgesi istenen dokümantasyon işlerinde kullan.
---
# Dokümantasyon

## Ne zaman
Yeni proje/paket README'si, mimari karar (ADR), API açıklaması, runbook veya CHANGELOG notu yazılırken.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Dil | sade Türkçe, kısa cümle; kod/komut/dosya adı İngilizce |
| ADR yolu | `docs/adr/NNNN-kisa-baslik.md` (sıradaki numara: `ls docs/adr`; şu an 0001–0004 var) |
| ADR durumu | `Kabul` + tarih (bugün) |
| API kaynağı | `packages/contracts/openapi.yaml` (sözleşmeden türet, uydurma) |
| CHANGELOG | kök `CHANGELOG.md`: `## [sürüm] - tarih` + `### Eklendi / Değişti / Düzeltildi`, satır öneki `api:` `web:` `compute:` `contracts:` `ai:` |
| Komutlar | repoda **çalıştırıp doğrulanmış** olanlar: `make dev`, `make test`, `make lint`, `make doctor`, `make audit`, `make test-hooks`, `make sync-cursor` |

Sorma. Çalıştıramadığın komutu "doğrulanmadı" diye işaretle.

## Adımlar
1. Ne tür belge: README / ADR / API / runbook / CHANGELOG.
2. İlgili gerçek dosyaları oku (kod, Makefile, openapi.yaml); yol ve komutları oradan al.
3. Aşağıdaki şablonu kullan; fazlalık yazma.
4. Komutları çalıştır veya gerçekten var olduklarını kontrol et.
5. Bağlantıların gerçek dosyaya gittiğini doğrula (`ls`).
6. Sürüm/ajan rehberi kuralları: ajan kuralları değiştiyse `AGENTS.md` içindeki `AGENTS_BASE_VERSION` artırılır (`05-surumleme.md`); yalnızca doküman değişikliği web sürümünü artırmaz.
7. Gerçek veri/sır/kişisel veri yazma; örneklerde sentetik değer ve `<YER_TUTUCU>`.

## Şablon
README:
````markdown
# <Ad>
<Tek cümle amaç.>

## Hızlı başlangıç
```bash
make doctor
make test
```
## Yapı
- `apps/web` — Next.js arayüzü
- `services/api` — Go API
## Katkı
Bkz. `CONTRIBUTING.md` · `docs/katki-rehberi.md`
````

ADR (`docs/adr/0005-<baslik>.md`; mevcut 0003 biçimiyle aynı):
```markdown
# ADR 0005: <Karar başlığı>
**Durum:** Kabul · **Tarih:** <YYYY-AA-GG>

## Bağlam
<Sorun ve kısıtlar, 2-4 cümle.>

## Karar
- <Somut karar ve yol/dosya referansı>

## Alternatifler
- <Seçenek>: <neden seçilmedi>

## Sonuçlar
- <Artılar, eksiler, yapılacaklar>

## İlgili
<skill/rule/dosya bağlantıları>
```

API örneği (OpenAPI'dan türetilmiş):
````markdown
### GET /series/{code}
Seriyi koduyla getirir. `code`: en çok 64 karakter.
Yanıtlar: `200` Series · `400` geçersiz kod · `404` seri bulunamadı (hata gövdesi `{"error":{"code","message"}}`).
```bash
curl -s localhost:8080/series/ORNEK-ENDEKS
```
````

## Örnek
Girdi: "Veri adaptörü kararını ADR yap." → `docs/adr/0005-veri-adaptoru-ek.md`: bağlam/karar/alternatifler/sonuçlar dolu; `ls docs/adr` ile numara doğrulandı; `CHANGELOG.md` `ai:` satırı eklendi.

## Bitti kontrol listesi
- [ ] Komutlar çalışıyor (veya "doğrulanmadı")
- [ ] Yol ve bağlantılar gerçek
- [ ] ADR'de bağlam, karar, alternatifler, sonuçlar var
- [ ] API örnekleri sözleşmeyle uyumlu
- [ ] Gerçek veri/sır yok; Türkçe sade
- [ ] CHANGELOG / ajan rehberi sürümü gerektiğinde güncel

## Sık hatalar
- Çalışmayan komutu veya var olmayan yolu yazmak.
- ADR'yi sonradan yazıp "alternatifler"i boş bırakmak.
- API belgesini koddan değil tahminden yazmak.
- Çok uzun, tekrar eden README.
- Kurumsal eşik/yöntemi koda veya belgeye sabit gömmek (parametre; kurum kararı).

## İlgili
`doc-writer` ajanı · `docs/adr/` · `docs/katki-rehberi.md` · `CHANGELOG.md` · `.claude/rules/05-surumleme.md`
