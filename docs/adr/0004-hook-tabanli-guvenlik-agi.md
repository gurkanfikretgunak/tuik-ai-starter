# ADR 0004: Hook tabanlı güvenlik ağı ve zafiyet takibi
**Durum:** Kabul · **Tarih:** 2026-11-09

## Bağlam
Kurallar tek başına uygulatılamaz; yapay zekâ kaynaklı riskler (veri sızıntısı, uydurma paket, güvensiz kod, aşırı yetki) var. Kural bir rica, hook bir uygulatıcıdır.

## Karar
Claude hook'ları ile ilk savunma hattı kurulur (`.claude/hooks/`, kayıt `settings.json`):
| Olay | Hook |
|---|---|
| SessionStart | `session-start-uyari.py` |
| UserPromptSubmit | `prompt-guard.py` |
| PreToolUse | `block-sensitive-files.sh`, `command-guard.py` |
| PostToolUse | `post-write-scan.py` |
| Stop | `stop-hatirlatma.py` |
Zafiyetler `docs/security/zafiyet-kayitlari.md` içinde `ZAF-YYYY-NNN`, sahip ve hedef tarihle izlenir (`scripts/vuln-track.py`, `make audit`). Testler: `make test-hooks`.

## Sınırlar
Regex tabanlıdır; kasıtlı atlatmayı önlemez; kod incelemesi ve CI yerine geçmez. Yanlış pozitifler beklenir (TCKN için sağlama algoritması bu yüzden kullanılır).

## Alternatifler
- Yalnız kural metni: uygulatılmaz.
- Yalnız CI taraması: sızıntı commit'ten önce engellenemez.

## Sonuçlar
Her yeni hook için test, README satırı ve `settings.json` kaydı zorunludur (`docs/katki-rehberi.md`). Hook bulguları haftalık gözden geçirilir (`make audit-list`).

## İlgili
`docs/egitim/08-guvenlik-hook-zafiyet.md` · `.claude/rules/14-zafiyet-takibi.md`
