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
