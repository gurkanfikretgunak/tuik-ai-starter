# Plan: <proje adı>
En çok 7 adım. Adım 1 ≤ 1 saat. Her adımın kabul ölçütü bir komut ve beklenen sonuçtur.

| # | Adım | Çıktı | Kabul ölçütü (komut → beklenen) |
|---|---|---|---|
| 1 | Şablonu kopyala + sentetik veri adaptörü | `projects/<ad>/` | `make test` → yeşil |
| 2 | Sözleşme taslağı | `packages/contracts/openapi.yaml` | spec geçerli, `Error` şeması var |
| 3 | API ucu (`go-api-endpoint`) | handler + use case + test | `cd services/api && go test ./...` → geçti |
| 4 | Web ekranı (`nextjs-sayfa-bilesen`) | sayfa + durumlar | `cd apps/web && npm test` → geçti |
| 5 | Hesaplama (`py-hesaplama-modulu`) | modül + test | `cd compute && python -m pytest -q` → geçti |
| 6 | Kalite ve güvenlik | `kvkk-kontrol`, `ifsa-kontrolu`, `make audit` | bulgu yok / kayda işlendi |
| 7 | Doküman ve teslim | README, CHANGELOG, `/ship` | `make lint test` → temiz |

Kullanılmayan satırları sil. Her adımdan sonra çalıştır, test et, commit'le (`feat(kapsam): ...`).
