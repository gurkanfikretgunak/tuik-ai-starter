# Hook'lar — otomatik güvenlik ağı

Hook'lar, Claude bir işlem yapmadan önce/sonra otomatik çalışan küçük betiklerdir. Kural yazmak "rica"dır; hook **uygulatır**. `settings.json` içinde tanımlıdır, yalnızca Python 3 standart kütüphanesi gerekir.

| Hook | Olay | Ne yapar | Sonuç |
|---|---|---|---|
| `session-start-uyari.py` | SessionStart | Yapay zekâ kullanım uyarısını ve açık zafiyet özetini bağlama ekler | bilgi |
| `prompt-guard.py` | UserPromptSubmit | Prompt'ta geçerli T.C. kimlik no, IBAN, token, özel anahtar arar; tablo/mikro veri ifadelerinde uyarır | sert eşleşmede **engeller** |
| `block-sensitive-files.sh` | PreToolUse (Read/Edit/Write/Bash) | `.env`, `data/raw/`, `data/private/`, anahtar dosyalarına erişimi keser | **engeller** (exit 2) |
| `command-guard.py` | PreToolUse (Bash) | `curl \| sh`, force push, `--no-verify`, `sudo`, yıkıcı SQL gibi komutları reddeder; **yeni paket kurulumunda onay ister** | reddeder / sorar |
| `post-write-scan.py` | PostToolUse (Write/Edit) | Yazılan dosyada sır/PII ve riskli kod kalıplarını (OWASP odaklı) tarar; bağımlılık dosyası değişince tarama hatırlatır | geri bildirim / uyarı |
| `stop-hatirlatma.py` | Stop | Kod değiştiyse test, audit ve inceleme hatırlatır | bilgi |

Bulgular `.claude/logs/hook-bulgular.jsonl` içine yazılır (git'e girmez). Özet: `make audit-list`.

## Zafiyet takibi akışı
1. **Algıla:** `make audit` (npm audit, pip-audit, govulncheck) ve `post-write-scan` uyarıları.
2. **Kaydet:** yeni bulgular `docs/security/zafiyet-kayitlari.md` tablosuna `ZAF-YYYY-NNN` ile eklenir (`--write` veya `scripts/vuln-track.py add`).
3. **Ata ve süre ver:** sorumlu + hedef tarih (önem düzeyine göre).
4. **Düzelt ve doğrula:** düzeltme + test; durum `Düzeltildi`.
5. **İzle:** her oturum başında özet gösterilir; süresi geçenler vurgulanır.

## Test ve geliştirme
```bash
make test-hooks                                  # tüm hook testleri
echo '{"prompt":"..."}' | python3 .claude/hooks/prompt-guard.py   # tek hook'u elle dene
```
- Girdi: stdin'de JSON; çıktı: stdout'ta JSON (`decision`, `permissionDecision`, `additionalContext`, `systemMessage`) veya exit 2.
- Yeni hook eklerken: `tests` ekle (`scripts/test-hooks.sh`), `README` tablosunu ve `settings.json`'u güncelle, **yanlış pozitif** oranını düşün (TCKN için sağlama algoritması bu yüzden var).

## Sınırlar (dürüst uyarı)
Hook'lar regex tabanlı ilk savunma hattıdır; her riski yakalamaz ve kasıtlı atlatmaya karşı korumaz. Kod incelemesi, CI taraması ve kurumsal güvenlik süreçlerinin yerine geçmez.
