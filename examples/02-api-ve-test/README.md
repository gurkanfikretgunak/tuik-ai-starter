# Örnek 2: API ve test

## Ne öğretir
Sözleşme-öncelikli endpoint ekleme: önce `openapi.yaml`, sonra test, sonra handler.

## Önkoşul
Go kurulu; `cd services/api && go test ./...` çalışıyor.

## Çalıştırma
```
/new-endpoint GET /series/{kod} Gösterge serisini döndürür
```
Not: sözleşmede `/series/{code}` ucu zaten vardır (`packages/contracts/openapi.yaml`); komut onu genişletir veya yeni bir uç için aynı deseni izler.
```bash
cd services/api && go vet ./... && go test ./...
cd services/api && go run ./cmd/api &    # sonra:
curl -i http://localhost:8080/series/<KOD>
```

## Beklenen çıktı
- Önce `openapi.yaml` değişir (200/400/404 yanıtları, `Error` şeması).
- `internal/application/getseries/` altında use case + başarılı ve hata yolu testleri; `internal/handler/series.go` ince kalır.
- Bilinmeyen kod → 404 `{"error":{"code":...,"message":...}}`; `CHANGELOG.md`'de `api:` satırı.

## Kontrol
Önce `openapi.yaml` değişti mi? Başarılı + hata yolu testleri var mı? `go test ./...` yeşil mi? İstemci eşit mi (`/regenerate-client`)?

## Dosya haritası
`packages/contracts/openapi.yaml` · `services/api/internal/{handler,application/getseries,domain,infrastructure/memory}` · `packages/api-client-ts/src`.
