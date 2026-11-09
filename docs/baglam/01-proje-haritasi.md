# Proje haritası: hangi dosya ne işe yarar

Bu harita gerçek dosya ağacından çıkarıldı. Küçük/yerel bir modele bağlam verirken önce bu dosyayı, sonra yalnızca ilgili katmanın dosyalarını ver.

## Ne zaman
- "Bu işi nereye yazayım?" sorusunda.
- Modele hangi dosyaları vereceğini seçerken (bkz. `docs/yerel-llm.md`).

## Katman özeti
| Klasör | Dil | Görev | Katman kuralı |
|---|---|---|---|
| `apps/web` | TypeScript (Next.js App Router) | Arayüz | `.claude/rules/web-nextjs.md` |
| `services/api` | Go | HTTP API | `.claude/rules/backend-go.md` |
| `compute` | Python | Hesaplama (ağırlık, endeks, ifşa) | `.claude/rules/hesaplama-python.md` |
| `packages/contracts` | OpenAPI YAML | Tek sözleşme kaynağı | `docs/adr/0002-sozlesme-oncelikli-gelistirme.md` |
| `packages/api-client-ts` | TypeScript | El yazımı tipli API istemcisi | skill: `api-client-ts` |
| `data/sample` | CSV/JSON | Yalnızca sentetik veri | `.claude/rules/01-veri-gizliligi.md` |
| `.claude` | Markdown/Python/Bash | Rule, skill, command, agent, hook | `docs/katki-rehberi.md` |
| `agents-local` | - | Faz 2, henüz aktif değil | `.claude/rules/vision-local.md` |

## apps/web
| Dosya | İşlev |
|---|---|
| `apps/web/src/app/layout.tsx` | Kök yerleşim (HTML iskeleti, dil, ortak çerçeve) |
| `apps/web/src/app/page.tsx` | Ana sayfa |
| `apps/web/src/lib/format.ts` | `formatNumber(value, digits)`: Türkçe sayı biçimi |
| `apps/web/src/lib/tr-search.ts` | `foldTr`, `matchesTr`, `highlightTr`: Türkçe karakter duyarsız arama |
| `apps/web/src/lib/data/types.ts` | `Seri`, `Gozlem`, `Durum`, `SeriDataSource` tipleri |
| `apps/web/src/lib/data/index.ts` | `getDataSource()`: veri kaynağı TEK yerden seçilir (`DATA_SOURCE`, varsayılan `sample`) |
| `apps/web/src/lib/data/sample-source.ts` | Sentetik kaynak uygulaması |
| `apps/web/src/lib/**/*.test.ts` | Vitest testleri (`format`, `tr-search`, `data`) |
| `apps/web/package.json` | Sürümün tek doğruluk kaynağı; betikler: dev, build, start, lint, test |
| `apps/web/CLAUDE.md` | Web katmanına özel talimat |

## services/api (katmanlı: domain → application → handler)
| Dosya | İşlev |
|---|---|
| `services/api/cmd/api/main.go` | Giriş noktası; sunucuyu başlatır |
| `services/api/internal/handler/health.go` | `GET /health` ve `NewMux()` (tüm rotaların bağlandığı yer) |
| `services/api/internal/handler/series.go` | `GET /series/{code}` handler'ı, `writeErr` hata biçimi |
| `services/api/internal/application/getseries/usecase.go` | `getseries.UseCase`: iş akışı (`Execute`) |
| `services/api/internal/domain/series.go` | `Series`, `Observation`, `SeriesRepository` arayüzü |
| `services/api/internal/infrastructure/memory/series_repo.go` | Bellek içi depo (`FindByCode`) |
| `services/api/internal/shared/errors/errors.go` | Ortak hata türleri |
| `services/api/Dockerfile`, `go.mod` | Derleme ve modül |
| `services/api/internal/**/*_test.go` | Go testleri (yanındaki dosya ile aynı klasör) |

## compute/src/tuik_calc
| Dosya | İşlevler |
|---|---|
| `disclosure.py` | `is_small_cell`, `is_dominated`, `suppress_row`, `secondary_suppress` (eşikler parametre; kurum kararı) |
| `weights.py` | `weighted_total`, `weighted_mean`, `coefficient_of_variation` |
| `indices.py` | `percent_change`, `chain_index` |
| `validation.py` | `Finding`, `check_range`, `check_required`, `check_unique`, `check_sum` |
| `compute/tests/test_*.py` | Her modülün pytest testi |
| `compute/pyproject.toml` | Paket ve araç yapılandırması |

## packages ve data
| Dosya | İşlev |
|---|---|
| `packages/contracts/openapi.yaml` | Rotalar: `/health`, `/series/{code}`. API değişikliği buradan başlar |
| `packages/api-client-ts/src/index.ts` | `createClient`, `ApiError`, `CLIENT_GAPS` |
| `packages/api-client-ts/src/types.ts` | Sözleşmeden türeyen tipler |
| `data/sample/ornek_seri.csv` | Sütunlar: `donem,bolge,deger` (sentetik) |
| `data/sample/sentetik-seri.json` | `scripts/generate-sample-data.mjs` ile üretilir |

## scripts
| Dosya | İşlev |
|---|---|
| `scripts/doctor.sh` | git, node, npm, go, python3, make kurulu mu |
| `scripts/vuln-track.py` | Zafiyet tarama ve kayıt yönetimi |
| `scripts/test-hooks.sh` | Hook davranış testleri |
| `scripts/sync-cursor.py` | `.claude` içeriğinden `.cursor` üretir |
| `scripts/generate-sample-data.mjs` | Seed'li sentetik veri üretir |

## .claude
| Yol | İşlev |
|---|---|
| `.claude/settings.json` | Hook bağları (oturum başı, prompt, araç öncesi/sonrası, durdurma) |
| `.claude/hooks/` | `prompt-guard.py`, `block-sensitive-files.sh`, `command-guard.py`, `post-write-scan.py`, `session-start-uyari.py`, `stop-hatirlatma.py`, `_common.py` |
| `.claude/rules/` | Her zaman geçerli kurallar (00–14, `backend-go`, `hesaplama-python`, `web-nextjs`, `test`, `vision-local`) |
| `.claude/skills/<ad>/SKILL.md` | Uzmanlık akışları (25 skill) |
| `.claude/commands/` | `/slash` komutları (16 komut) |
| `.claude/agents/` | `planner`, `reviewer`, `test-writer`, `doc-writer`, `data-privacy-auditor` |
| `.claude/skills/kvkk-kontrol/scan.sh` | Basit hassas içerik taraması |

## Diğer
| Yol | İşlev |
|---|---|
| `CLAUDE.md`, `AGENTS.md` | Ajan talimatları |
| `Makefile` | Komutlar (bkz. `04-komut-referansi.md`) |
| `CHANGELOG.md` | Sürüm notları (`api:`, `web:`, `compute:` önekleri) |
| `docs/adr/` | Mimari kararlar | 
| `docs/egitim/` | 8 eğitim notu |
| `docs/security/` | `ai-kullanim-riskleri.md`, `zafiyet-kayitlari.md` |
| `docs/runbooks/` | Paylaşımlı ortam kuralları, yayın kontrol listesi |
| `templates/` | Yeni proje şablonları (fullstack-minimal, go-service, py-calculation, web-dashboard) |
| `examples/` | 5 örnek akış |
| `.cursor/` | OTOMATİK üretilir; elle düzenleme (`make sync-cursor`) |

## Sık hatalar
- `.cursor/` altını elle düzenlemek: bir sonraki eşitlemede silinir.
- İkinci sözleşme dosyası açmak: tek dosya `packages/contracts/openapi.yaml`.
- Eşik değerini koda gömmek: parametre yap.

## İlgili
`02-tarifler.md`, `04-komut-referansi.md`, `docs/yerel-llm.md`.
