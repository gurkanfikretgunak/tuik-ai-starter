# Komut referansı

Kaynaklar: `Makefile`, `scripts/`, `.claude/commands/`. Komutlar kök dizinden çalıştırılır.

## make hedefleri
| Hedef | Ne yapar | Not |
|---|---|---|
| `make dev` | Yalnızca nasıl başlatılacağını yazdırır | api: `cd services/api && go run ./cmd/api`; web: `cd apps/web && npm run dev`; calc: `cd compute && python -m pytest` |
| `make test` | `go test ./...` (services/api) ve `python -m pytest -q` (compute) | Web testi dahil DEĞİL; web için `cd apps/web && npm test` |
| `make lint` | `go vet ./...` ve `ruff check .` | Ruff hatası bu hedefte `|| true` ile yutulur; ayrıca elle bak |
| `make doctor` | `scripts/doctor.sh`: git, node, npm, go, python3, make var mı | Çıktı: OK / EKSIK |
| `make audit` | `python3 scripts/vuln-track.py scan --write` | Yeni bulguları kayıt defterine ekler |
| `make audit-list` | Açık zafiyetler + hook bulguları | `vuln-track.py list` ve `hooks` |
| `make test-hooks` | `scripts/test-hooks.sh` | Hook davranış testi; HATA satırı varsa başarısız |
| `make kvkk` | `scripts/kvkk/run-all.sh` | KVKK/sır/mikro veri taraması (maskeli çıktı); `kvkk-staged`, `kvkk-strict`, `kvkk-history` varyantları |
| `make test-kvkk` | `scripts/kvkk/test-kvkk.sh` | KVKK kontrolcülerinin sentetik fixture testleri |
| `make kvkk-hook` | `scripts/kvkk/install-git-hooks.sh` | Commit öncesi KVKK kontrolünü yerel git hook'u olarak kurar (isteğe bağlı) |
| `make sync-cursor` | `scripts/sync-cursor.py` | `.claude` → `.cursor` |

## Web komutları (`apps/web/package.json`)
| Komut | İşlev |
|---|---|
| `npm run dev` | Geliştirme sunucusu |
| `npm run build` / `npm run start` | Derle / çalıştır |
| `npm run lint` | `next lint` |
| `npm test` | `vitest run` |

## scripts/
| Betik | Kullanım |
|---|---|
| `bash scripts/doctor.sh` | Ortam kontrolü |
| `python3 scripts/vuln-track.py summary` | Kısa özet |
| `python3 scripts/vuln-track.py list` | Açık kayıtlar |
| `python3 scripts/vuln-track.py scan [--write]` | npm audit / pip-audit / govulncheck; araç yoksa atlar |
| `python3 scripts/vuln-track.py add --kaynak X --bilesen Y --ozet "..." --onem Yüksek --sorumlu ekip` | Elle kayıt |
| `python3 scripts/vuln-track.py hooks` | Hook bulgu günlüğü özeti |
| `bash scripts/test-hooks.sh` | Hook testleri |
| `python3 scripts/sync-cursor.py` | Cursor çıktısını üretir |
| `node scripts/generate-sample-data.mjs [seed]` | `data/sample/sentetik-seri.json` üretir (deterministik) |
| `bash .claude/skills/kvkk-kontrol/scan.sh [klasör]` | Basit hassas içerik taraması; ilk savunma hattı |

## Slash komutları
| Komut | Argüman | Amaç |
|---|---|---|
| `/new-feature` | `<özellik>` | Plan, kod, test |
| `/new-endpoint` | `<METHOD> <yol> <amaç>` | Go endpoint (sözleşme + handler + test) |
| `/new-page` | `<sayfa/bileşen>` | Next.js sayfa/bileşen |
| `/new-calc` | `<hesaplama tanımı>` | Python hesaplama modülü |
| `/new-project` | `<ad> [web\|api\|calc\|fullstack]` | Şablondan proje |
| `/new-surec` | `<gösterge/anket/hesap>` | GSBPM eşleme |
| `/ifsa-kontrol` | `<tablo veya uç nokta>` | İfşa kontrolü |
| `/kalite-kontrol` | `<dosya veya gösterge>` | Doğrulama ve kalite raporu taslağı |
| `/regenerate-client` | - | TS istemcisini sözleşmeyle eşitle |
| `/audit` | - | Zafiyet taraması |
| `/ai-risk` | `<senaryo>` | AI kullanım riski |
| `/review` | - | Değişiklik incelemesi |
| `/ship` | - | Test + lint + commit + PR hazırlığı |
| `/dev-fullstack` | - | Tüm yığını yerelde başlat |
| `/explain` | `<dosya veya kavram>` | Öğretici açıklama |
| `/learn` | `<prompt\|claude-code\|skill\|guvenlik\|proje-baslatma>` | Eğitim |

## Hook'lar (otomatik)
| Olay | Betik | Etki |
|---|---|---|
| Oturum başı | `session-start-uyari.py` | Zafiyet özeti, uyarı |
| Prompt | `prompt-guard.py` | Geçerli TCKN veya bulut anahtarı içeren promptu engeller; anahtar kelimede uyarır |
| Araç öncesi (Read/Edit/Write/Bash) | `block-sensitive-files.sh` | Hassas dosya/klasör erişimini engeller |
| Araç öncesi (Bash) | `command-guard.py` | Riskli komut denetimi |
| Araç sonrası (Write/Edit) | `post-write-scan.py` | Yazılan içeriği tarar |
| Durdurma | `stop-hatirlatma.py` | Bitirme hatırlatması |

Bir hook engellerse: içeriği/komutu değiştir, hook'u atlatma.

## Sık hatalar
- `make test` yeşil diye web'i test edilmiş sanmak.
- `make lint` yeşil diye ruff temiz sanmak (hata yutulur).
- `make dev` sunucu başlatır sanmak: yalnızca yönerge yazdırır.

## İlgili
`02-tarifler.md`, `.claude/hooks/README.md`, `docs/katki-rehberi.md`.
