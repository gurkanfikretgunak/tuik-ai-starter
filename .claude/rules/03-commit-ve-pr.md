# Commit ve PR kuralları
(MasterFabric core-base pratiğinden uyarlanmıştır.)

## Commit türü seçimi
1. **Varsayılan — Tür 1:** `tip(kapsam): emir kipinde özet` — örn. `feat(web): seri sayfası eklendi`, `docs(changelog): ...`
2. **Tek bir iş kaydı (ticket) konuyu belirliyorsa — Tür 2:** `feat(TUIK-12): açıklama`
3. **Çok küçük, tek paketlik iş — Tür 3:** `api: sağlık ucu zaman aşımı`
Tipler: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`. Kapsamlar: `web`, `api`, `compute`, `contracts`, `ai` (`.claude/`), `docs`.
Aynı PR içinde türleri gereksiz karıştırma.

## Pull request
- GitHub `gh repo view --json defaultBranchRef` ile **varsayılan dalı** öğren; dalı tahmin etme.
- Yanlış dala giden işi `cherry-pick` ile taşıma; merge PR aç. Çakışma çıkarsa dur ve bildir.
- Tek, tutarlı dilim: başlık ve açıklama diff ile örtüşmeli; ilgisiz refactor ayrı PR.
- Açıklama: **ne**, **neden**, **nasıl doğrulanır**, **risk/geri alma** (migrasyon, yetki, veri silme varsa), **ön inceleme** kontrol listesi.
- Açıklamayı "Ready" yapmadan önce **insan sesiyle** yaz: kısa, düz paragraflar; araç çıktısı gibi katı madde dökümü bırakma.
- Backend + web birlikte değişiyorsa hangisinin önce yayına gideceğini yaz (önce API, sonra istemci).
- Birleştirmeden önce sırayla: işi bitir → ship checklist (`04-ship-checklist.md`) → PR'ı güncelle → Ready → CI → merge → dalı sil.
