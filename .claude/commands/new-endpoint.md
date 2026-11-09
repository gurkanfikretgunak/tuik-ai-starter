---
description: Go servisine yeni API endpoint'i ekle (sözleşme + handler + test)
argument-hint: <METHOD> <yol> <amaç>
---
Endpoint: $ARGUMENTS

## Ne zaman
Go servisine (`services/api`) yeni uç nokta eklenirken.

## Argüman sözdizimi ve varsayılanlar
`/new-endpoint <METHOD> <yol> <amaç>` — örn. `/new-endpoint GET /v1/seriler/{id} tek seriyi döndür`.

| Eksik girdi | Varsayım |
|---|---|
| Yol öneki | `/v1/...`, mevcut yol adlandırmasını izle |
| Hata biçimi | Mevcut handler'ların hata gövdesi |
| Yetki | Mevcut uçlarla aynı |
| Veri | Sentetik; yayımlanan tablo ise ifşa kontrolü gerekli |

## Kullanılan skill/kural
`go-api-endpoint` (ana); `ifsa-kontrolu` (istatistik döndürüyorsa), `api-client-ts` (istemci). Kurallar: `.claude/rules/backend-go.md`, `06-mimari-katmanlar.md`, `02-guvenlik.md`, `04-ship-checklist.md`.

## Adımlar
1. `packages/contracts/openapi.yaml` içine yolu, parametreleri, yanıt ve hata şemalarını ekle (tek sözleşme dosyası).
2. `services/api/internal` altındaki katmanlara bak: `handler` → `application` → `domain` → `infrastructure`.
3. Testleri yaz: başarılı yol + geçersiz girdi (400) + bulunamadı (404).
4. Domain/service mantığını, sonra handler'ı yaz; girdiyi sunucuda doğrula.
5. Yolu router'a bağla (`services/api/cmd/api`).
6. `make test` ve `make lint`.
7. İstek koleksiyonu varsa genişlet; `CHANGELOG.md` içine `api:` notu.
8. TS istemcisi etkileniyorsa `/regenerate-client`.

## Çıktı biçimi
Değişen dosyalar, sözleşme farkı özeti, test sonucu, `curl` örneği.

## Örnek
`/new-endpoint GET /v1/seriler/{id} seri detayı` → sözleşme + handler + 3 test + `curl localhost:8080/v1/seriler/ornek`.

## Bitti kontrol listesi
- [ ] Önce sözleşme güncellendi.
- [ ] Başarılı yol ve hata yolu testleri geçiyor.
- [ ] Girdi doğrulaması var; sır/kişisel veri yok.
- [ ] `CHANGELOG.md` `api:` notu eklendi.

## Sık hatalar
- Kodu sözleşmeden önce yazmak.
- İş mantığını handler'a koymak (katman ihlali).
- İkinci bir sözleşme dosyası açmak.
