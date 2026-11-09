---
name: go-api-endpoint
description: Go backend'e yeni endpoint ekler (OpenAPI → handler → service → test). API işlerinde kullan.
---
# Go endpoint
1. `packages/contracts/openapi.yaml` içine yol, istek/yanıt şeması ve hata kodlarını ekle.
2. `internal/handler`: ayrıştır, doğrula, service'i çağır, JSON yanıt ver. İş mantığı yok.
3. `internal/service`: iş mantığı, `context.Context` ilk parametre, sarılmış hatalar.
4. Tablo-güdümlü test: başarılı yol, geçersiz girdi, servis hatası (`httptest`).
5. `go vet ./... && go test ./...` temiz olmalı.
Hata yanıtı biçimi: `{"error": {"code": "...", "message": "..."}}`.
