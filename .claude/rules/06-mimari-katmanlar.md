---
paths:
  - "services/**/*.go"
---
# Go mimari katmanları
```
HTTP handler → Application (use case) → Domain (varlık) ← Infrastructure (DB, önbellek, dış servis)
```
- Bağımlılık yönü katıdır: `domain` hiçbir şeye bağımlı değil; `application` yalnızca `domain`'e; `infrastructure` ikisini uygular.
- Use case imzası: `Execute(ctx context.Context, req Request) (Response, error)`.
- Hata sabitleri `internal/shared/errors` içinde (sentinel); katmanlar `errors.Is` ile kontrol eder, handler HTTP koduna çevirir.
- Sözleşme (`packages/contracts/openapi.yaml`) kaynak gerçektir; kod ona uyar, tersi değil.
- Dizin: `internal/{domain,application,infrastructure,shared/errors,handler}`.

## Gerçek yapı (`services/api/`)
| Katman | Yol |
|---|---|
| Giriş | `cmd/api/main.go` |
| Handler | `internal/handler/{health,series}.go` |
| Use case | `internal/application/getseries/usecase.go` |
| Domain | `internal/domain/series.go` |
| Altyapı | `internal/infrastructure/memory/series_repo.go` |
| Hata sabitleri | `internal/shared/errors/errors.go` |

## Bu kod nereye? (evet/hayır)
| Kod | Yer |
|---|---|
| HTTP durum kodu, JSON yazma | handler |
| İş akışı, doğrulama, orkestrasyon | application |
| Varlık, değişmez kural | domain |
| DB/önbellek/dış servis çağrısı | infrastructure |
| `net/http` import'u | yalnızca handler |
| Domain'de `database/sql` importu | YASAK |

## Örnek use case iskeleti
```go
type UseCase struct{ repo domain.SeriesRepository }
func (u *UseCase) Execute(ctx context.Context, req Request) (Response, error) {
    s, err := u.repo.Get(ctx, req.Code)
    if err != nil { return Response{}, fmt.Errorf("get series: %w", err) }
    return Response{Series: s}, nil
}
```
- Handler: `errors.Is(err, apperrors.ErrNotFound)` → 404. Yeni katman/bağımlılık yönü ihlali yapma.
