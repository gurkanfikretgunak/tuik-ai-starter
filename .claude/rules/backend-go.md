---
paths:
  - "services/**"
---
# Go kuralları
- Katmanlar ve use case deseni: `06-mimari-katmanlar.md`. Handler iş mantığı içermez.
- Hatalar sarılır (`fmt.Errorf("...: %w", err)`); `panic` yok.
- `context.Context` ilk parametre. Zaman aşımı ve iptal desteklenir.
- Standart kütüphane öncelikli. Tablo-güdümlü testler (`*_test.go`).
- `go vet` ve `gofmt` temiz olmadan iş bitmez.

## Evet / Hayır
| Durum | Doğru | Yanlış |
|---|---|---|
| Hata | `fmt.Errorf("get series: %w", err)` | `panic`, hatayı yutma |
| Context | `func (u *UseCase) Execute(ctx context.Context, ...)` | context'siz uzun çağrı |
| Test | tablo-güdümlü `*_test.go` | tekil kopya testler |
| Bağımlılık | standart kütüphane önce | gereksiz paket |
| Handler | JSON/HTTP kodu | iş mantığı |

```go
func TestGetSeries(t *testing.T) {
    cases := []struct{ name, code string; wantErr bool }{
        {"found", "ORNEK-001", false}, {"missing", "YOK", true},
    }
    for _, tc := range cases { t.Run(tc.name, func(t *testing.T) { /* ... */ }) }
}
```
Bitirmeden: `cd services/api && gofmt -l . && go vet ./... && go test ./...`. Yeni uç: `/new-endpoint`.
