# services/api (Go)
Katmanlar: handler → service → repository. Yeni endpoint için `/new-endpoint`. Sözleşme: `packages/contracts/openapi.yaml`.
Çalıştır: `go run ./cmd/api` · Test: `go test ./...`

## Dizin haritası
| Yol | İçerik |
|---|---|
| `cmd/api/main.go` | giriş noktası |
| `internal/handler/` | `health.go`, `series.go` (+ `health_test.go`) |
| `internal/application/getseries/` | use case + test |
| `internal/domain/series.go` | varlık |
| `internal/infrastructure/memory/series_repo.go` | bellek içi depo |
| `internal/shared/errors/errors.go` | sentinel hatalar |
| `api/` | istek koleksiyonu/ortam dosyası alanı (varsa tek koleksiyon) |
| `go.mod` | Go 1.22 |
Sözleşme: `packages/contracts/openapi.yaml` (`/health`, `/series/{code}`).

## Komutlar
`cd services/api && go run ./cmd/api` · `go test ./...` · `go vet ./...` · `gofmt -l .` · Hepsi: `make test`, `make lint`.

## Adlandırma ve test deseni
- Paket adı küçük harf tek kelime; use case `Execute(ctx, req) (Response, error)`; hata `fmt.Errorf("...: %w", err)`.
- Test yanında `*_test.go`, tablo-güdümlü; hata yolu zorunlu.

## Yaygın görev → dosya
| Görev | Yap |
|---|---|
| Yeni endpoint | openapi.yaml → domain → `application/<ad>/usecase.go` → `handler/<ad>.go` → test → CHANGELOG `api:` (`/new-endpoint`) |
| Yeni hata türü | `shared/errors/errors.go` + handler'da HTTP kodu eşlemesi |
| Yeni depo/DB | `infrastructure/` altında; domain arayüzünü uygular |
| Sözleşme değişti | `/regenerate-client` (`packages/api-client-ts`) |
Kurallar: `.claude/rules/backend-go.md`, `06-mimari-katmanlar.md`, `10-ifsa-kontrolu.md`.
