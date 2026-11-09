# Şablon: fullstack-minimal

Kopyalanacak parçalar: `apps/web`, `services/api`, `compute`, `packages/contracts`. Yeni projede `projects/<ad>/` altına yerleştirilir.

## Ne öğretir
Sözleşme-öncelikli uçtan uca akış: OpenAPI → Go endpoint → Python hesap → Next.js sayfa (`docs/adr/0002-sozlesme-oncelikli-gelistirme.md`).

## Önkoşul
`git`, Node.js + npm, Go, Python >= 3.11 (`compute/pyproject.toml`), `make`. Kontrol: `make doctor`.

## Çalıştırma (kök dizinde gerçek komutlar)
```bash
make dev                                 # üç katmanın başlatma komutlarını yazdırır
cd services/api && go run ./cmd/api      # API, varsayılan :8080 (API_ADDR ile değişir)
cd apps/web && npm install && npm run dev
cd compute && python -m pytest -q
```
Beklenen: `curl http://localhost:8080/health` → `{"status":"ok"}`; testler yeşil.

## Dosya haritası
| Yol | İçerik |
|---|---|
| `apps/web/` | Next.js sayfaları (`src/app`), `src/lib/data` adaptörü, `tr-search`, `format` |
| `services/api/` | `cmd/api`, `internal/{handler,application,domain,infrastructure,shared}` |
| `compute/` | `src/tuik_calc/{indices,weights,disclosure,validation}.py` + `tests/` |
| `packages/contracts/` | `openapi.yaml` |

## Sonraki adım
Sözleşmeye ilk ucu ekle, `/new-endpoint`, `/new-calc`, `/new-page`; sonra `/review` ve `/ship`.
