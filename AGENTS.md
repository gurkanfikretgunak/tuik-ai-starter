# AGENTS.md
**`AGENTS_BASE_VERSION`:** `1.1.0` (bu rehberin sürümü; PATCH yazım · MINOR yeni bölüm/akış · MAJOR uyumsuz değişiklik — bkz. `.claude/rules/05-surumleme.md`).

Ana kurallar `CLAUDE.md` ve `.claude/rules/` altındadır; başka agent araçları (Cursor vb.) da bunları esas almalıdır. Cursor için `make sync-cursor` ile `.cursor/` üretilir (tek kaynak `.claude/`).

Özet: Next.js (web), Go (backend, katmanlı), Python (hesaplama); sözleşme önce; önce plan sonra kod ve test; gerçek veri ve sırlar asla paylaşılmaz; yayımlanan her istatistik doğrulama + ifşa kontrolünden geçer; yapay zekâ çıktısı doğrulanmadan kabul edilmez (`docs/security/ai-kullanim-riskleri.md`).
