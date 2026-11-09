# ADR 0004: Hook tabanlı güvenlik ağı ve zafiyet takibi
**Durum:** Kabul · **Tarih:** 2026-11-09
**Bağlam:** Kurallar tek başına uygulatılamaz; yapay zekâ kaynaklı riskler (veri sızıntısı, uydurma paket, güvensiz kod, aşırı yetki) var.
**Karar:** Claude hook'ları (SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, Stop) ile ilk savunma hattı kurulur; zafiyetler `docs/security/zafiyet-kayitlari.md` içinde sahip ve hedef tarihle izlenir.
**Sınırlar:** Regex tabanlıdır, kasıtlı atlatmayı önlemez; kod incelemesi/CI yerine geçmez.
