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
