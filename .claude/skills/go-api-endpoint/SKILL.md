---
name: go-api-endpoint
description: Go backend'e yeni endpoint ekler (OpenAPI → domain → use case → handler → test → CHANGELOG). services/api altında yeni uç nokta, istek/yanıt şeması veya hata kodu gerektiren her API işinde kullan.
---
# Go endpoint (services/api)

## Ne zaman
`services/api` altında yeni veya değişen HTTP ucu varsa. Önce sözleşme, sonra kod, sonra test (`.claude/rules/04-ship-checklist.md`).

## Girdiler ve varsayılanlar
Kullanıcı vermediyse **sorma**, şunu varsay:

| Girdi | Varsayılan |
|---|---|
| Yöntem | `GET` (okuma), `POST` (oluşturma) |
| Yol biçimi | küçük harf, çoğul kaynak: `/series`, `/series/{code}` |
| Modül yolu | `github.com/masterfabric/tuik-ai-starter/services/api` (`go.mod`) |
| Go sürümü | 1.22 (`GET /yol/{param}` kalıbı ve `r.PathValue` kullanılabilir) |
| Veri kaynağı | `internal/infrastructure/memory` (SENTETİK); gerçek depo sonra enjekte edilir |
| Yanıt dili | hata mesajı Türkçe, hata `code` İngilizce `snake_case` |
| Doğrulama | sunucuda zorunlu (boş değer, uzunluk ≤ 64) |
| Yetkilendirme | yok (iskelette tanımlı değil; ekleniyorsa sözleşmeye yaz) |

Yalnızca şu durumda sor: yeni uç **gizli/mikro veri** döndürecekse (önce `kvkk-kontrol` ve `ifsa-kontrolu`).

## Gerçek katman yapısı
```
services/api/
  cmd/api/main.go                          # API_ADDR (varsayılan :8080), http.Server
  internal/domain/series.go                # varlıklar + repository arayüzü (dış bağımlılık yok)
  internal/application/<usecase>/usecase.go  # iş mantığı: Request, Response, UseCase, Execute
  internal/handler/<ad>.go                 # HTTP: ayrıştır → use case → JSON
  internal/handler/health.go               # NewMux(): tüm rotalar burada bağlanır
  internal/infrastructure/memory/*.go      # bellek içi depo (sentetik)
  internal/shared/errors/errors.go         # ErrNotFound, ErrInvalidArg, ErrSuppressed
```
Not: eski notlarda "service" geçer; bu repoda iş mantığı `internal/application/<usecase>` paketindedir.

## Adımlar
1. **Sözleşme:** `packages/contracts/openapi.yaml` içine `paths` girdisi, `components/schemas` ve `400/404` hata yanıtları (`$ref: "#/components/schemas/Error"`). Tek sözleşme dosyası; ikinci dosya açma.
2. **Domain:** yeni varlık/arayüz gerekiyorsa `internal/domain/` altına ekle (JSON etiketleri `snake_case`; gizli hücre `*float64` = `nil`, asla 0).
3. **Depo:** arayüzü `internal/infrastructure/memory/` içinde uygula (sentetik veri).
4. **Use case:** `internal/application/<ad>/usecase.go` — `Execute(ctx, Request) (Response, error)`; ilk iş `ctx.Err()`; girdiyi doğrula; hataları `fmt.Errorf("...: %w", apperr.ErrX)` ile sar.
5. **Handler:** `internal/handler/<ad>.go` — iş mantığı yok; `errors.Is` ile `apperr` hatalarını HTTP koduna çevir (`ErrInvalidArg`→400, `ErrNotFound`→404, `ErrSuppressed`→200 + `null` veya 403 sözleşmeye göre, diğer→500).
6. **Bağla:** `internal/handler/health.go` içindeki `NewMux()` fonksiyonuna `mux.HandleFunc("GET /yol/{param}", ...)` ekle.
7. **Test:** use case için tablo-güdümlü test + handler için `httptest` testi (başarı, geçersiz girdi, bulunamadı, iptal edilmiş bağlam).
8. **Çalıştır:** `cd services/api && go vet ./... && go test ./...` (veya kökte `make lint test`).
9. **Ship:** `CHANGELOG.md` altına `### Eklendi` → `- api: <açıklama>`; istemci etkileniyorsa `api-client-ts` skill'ini çalıştır.

## Şablon

OpenAPI parçası (`paths` altına):
```yaml
  /indicators/{code}:
    get:
      summary: Göstergeyi koduyla getir
      parameters:
        - name: code
          in: path
          required: true
          schema: { type: string, maxLength: 64 }
      responses:
        "200":
          description: Gösterge
          content:
            application/json:
              schema: { $ref: "#/components/schemas/Indicator" }
        "400":
          description: Geçersiz kod
          content:
            application/json:
              schema: { $ref: "#/components/schemas/Error" }
        "404":
          description: Gösterge bulunamadı
          content:
            application/json:
              schema: { $ref: "#/components/schemas/Error" }
```

Use case (`internal/application/getindicator/usecase.go`):
```go
// Package getindicator, "göstergeyi koduyla getir" use case'idir.
package getindicator

import (
	"context"
	"fmt"
	"strings"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/domain"
	apperr "github.com/masterfabric/tuik-ai-starter/services/api/internal/shared/errors"
)

type Request struct{ Code string }
type Response struct{ Indicator domain.Indicator }

type UseCase struct{ repo domain.IndicatorRepository }

func New(repo domain.IndicatorRepository) *UseCase { return &UseCase{repo: repo} }

func (u *UseCase) Execute(ctx context.Context, req Request) (Response, error) {
	if err := ctx.Err(); err != nil {
		return Response{}, err
	}
	code := strings.TrimSpace(req.Code)
	if code == "" || len(code) > 64 {
		return Response{}, fmt.Errorf("kod: %w", apperr.ErrInvalidArg)
	}
	ind, err := u.repo.FindByCode(code)
	if err != nil {
		return Response{}, fmt.Errorf("gösterge %q: %w", code, err)
	}
	return Response{Indicator: *ind}, nil
}
```

Handler (`internal/handler/indicator.go`; `writeErr` zaten `series.go` içinde tanımlı, yeniden yazma):
```go
func GetIndicator(uc *getindicator.UseCase) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		resp, err := uc.Execute(r.Context(), getindicator.Request{Code: r.PathValue("code")})
		switch {
		case err == nil:
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(resp.Indicator)
		case errors.Is(err, apperr.ErrInvalidArg):
			writeErr(w, http.StatusBadRequest, "invalid_argument", "geçersiz kod")
		case errors.Is(err, apperr.ErrNotFound):
			writeErr(w, http.StatusNotFound, "not_found", "gösterge bulunamadı")
		default:
			writeErr(w, http.StatusInternalServerError, "internal", "beklenmeyen hata")
		}
	}
}
```

Use case testi (mevcut `getseries/usecase_test.go` kalıbı):
```go
func TestExecute(t *testing.T) {
	uc := New(memory.NewIndicatorRepo(domain.Indicator{Code: "ORNEK", Name: "Örnek (sentetik)"}))
	cancelled, cancel := context.WithCancel(context.Background())
	cancel()
	tests := []struct {
		name    string
		ctx     context.Context
		code    string
		wantErr error
	}{
		{"başarılı", context.Background(), "ORNEK", nil},
		{"boş kod", context.Background(), "  ", apperr.ErrInvalidArg},
		{"bulunamadı", context.Background(), "YOK", apperr.ErrNotFound},
		{"iptal edilmiş bağlam", cancelled, "ORNEK", context.Canceled},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			_, err := uc.Execute(tc.ctx, Request{Code: tc.code})
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("hata = %v, beklenen %v", err, tc.wantErr)
			}
		})
	}
}
```

Handler testi (`handler_test.go` kalıbı; `NewMux()` içindeki sentetik seri `ORNEK-ENDEKS`):
```go
{"var", "/series/ORNEK-ENDEKS", http.StatusOK},
{"yok", "/series/YOK", http.StatusNotFound},
// çağrı: NewMux().ServeHTTP(rec, httptest.NewRequest(http.MethodGet, tc.path, nil))
```

## Örnek
Girdi: `GET /series/ORNEK-ENDEKS` → 200
```json
{"code":"ORNEK-ENDEKS","name":"Örnek Fiyat Endeksi (sentetik)","unit":"endeks","observations":[{"period":"2024-01","region":"A","value":100,"status":"kesin"}]}
```
Girdi: `GET /series/YOK` → 404 `{"error":{"code":"not_found","message":"seri bulunamadı"}}`

Elle deneme: `cd services/api && go run ./cmd/api` ardından `curl -s localhost:8080/series/ORNEK-ENDEKS`.

## Bitti kontrol listesi
- [ ] `openapi.yaml` güncel; 400/404 şemaları var
- [ ] Hata gövdesi `{"error":{"code","message"}}` biçiminde
- [ ] Use case: `ctx` ilk parametre, hatalar `%w` ile sarılı
- [ ] Handler'da iş mantığı yok; rota `NewMux()` içinde bağlı
- [ ] Başarı + geçersiz girdi + bulunamadı + iptal testleri geçiyor
- [ ] `go vet ./... && go test ./...` temiz
- [ ] `CHANGELOG.md` `api:` satırı; istemci/web etkisi not edildi
- [ ] Yalnızca sentetik veri; gizli hücre `nil`

## Sık hatalar
- Sözleşmeyi güncellemeden handler yazmak.
- İş mantığını handler'a koymak; `err.Error()` metnini kullanıcıya sızdırmak.
- Gizli hücreyi `0` döndürmek (doğrusu `null` + `status: "gizli"`).
- `context.Context`'i yok saymak; hata sarmayıp `errors.Is` kırmak.
- Eski Go 1.21 stili `mux.HandleFunc("/series/", ...)` yazmak; bu repoda `"GET /series/{code}"` kullanılır.
- Panik, `log.Fatal` veya SQL'de string birleştirme (parametreli sorgu şart).

## İlgili
`/new-endpoint` · `api-client-ts` · `kvkk-kontrol` · `ifsa-kontrolu` · `.claude/rules/04-ship-checklist.md` · `services/api/CLAUDE.md`
