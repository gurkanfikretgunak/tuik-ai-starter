# Şablon: go-service

Kopyalanacak parça: `services/api` + `packages/contracts`.

## Ne öğretir
Katmanlı Go servisi (handler → use case → domain/repo) ve sözleşme-öncelikli endpoint ekleme.

## Önkoşul
Go (sürüm `services/api/go.mod` içinde), `make`.

## Çalıştırma
```bash
cd services/api && go run ./cmd/api     # dinler: :8080 (API_ADDR ile değiştir)
curl -s http://localhost:8080/health
cd services/api && go vet ./... && go test ./...
```
Beklenen: `/health` → `{"status":"ok"}`; `go test` → `ok` satırları.

## Dosya haritası
| Yol | İçerik |
|---|---|
| `cmd/api/main.go` | giriş noktası |
| `internal/handler/` | `health.go`, `series.go` |
| `internal/application/getseries/` | use case + test |
| `internal/domain/series.go` | varlık |
| `internal/infrastructure/memory/` | bellek içi depo |
| `internal/shared/errors/` | ortak hatalar |
| `packages/contracts/openapi.yaml` | sözleşme |

Yeni uç: `/new-endpoint` (önce `openapi.yaml`). Örnek: `examples/02-api-ve-test`.
