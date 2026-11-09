# 8. Hook'lar, zafiyet takibi ve AI riskleri
**Seviye:** Zorunlu · **Süre:** 45 dk

## Öğrenme hedefi
Hook'ların ne yakaladığını/yakalamadığını bilmek; zafiyet kaydı açıp sahip ve tarih atamak; AI'nın önerdiği paketi doğrulamak.

## Hook özeti (`.claude/hooks/README.md`)
| Hook | Olay | Etki |
|---|---|---|
| `session-start-uyari.py` | SessionStart | Uyarı + açık zafiyet özeti |
| `prompt-guard.py` | UserPromptSubmit | Kimlik no, IBAN, token, özel anahtar → engeller |
| `block-sensitive-files.sh` | PreToolUse | Hassas dosya/klasör erişimini keser |
| `command-guard.py` | PreToolUse (Bash) | Riskli komutu reddeder, paket kurulumunda onay ister |
| `post-write-scan.py` | PostToolUse | Yazılan dosyada sır/riskli kod tarar |
| `stop-hatirlatma.py` | Stop | Test/audit/inceleme hatırlatır |

## Adım adım alıştırma
1. `docs/security/ai-kullanim-riskleri.md` tablosunu okuyun; her riskin önlemini bulun.
2. `make test-hooks` çalıştırın; test dosyasındaki **sentetik** kimlik numarasının engellendiğini görün.
3. Tek hook'u elle deneyin: `echo '{"prompt":"merhaba"}' | python3 .claude/hooks/prompt-guard.py` (zararsız prompt geçer).
4. `make audit` ile tarama yapın; bulguyu `docs/security/zafiyet-kayitlari.md` içine `ZAF-YYYY-NNN` ile işleyin: kaynak, bileşen, önem, durum, **sorumlu**, **hedef tarih**.
5. `make audit-list` ile açık kayıtları ve hook bulgularını görün.
6. Yapay zekâdan bir paket önermesini isteyin; `command-guard` onay penceresinde şunları doğrulayın: paket gerçekten var mı, bakımı sürüyor mu, lisansı uygun mu, ad benzerliği (typosquatting) yok mu?

## Örnek prompt'lar
**Kötü:** `Şu paketi kur, çalışır herhalde.`
**İyi:**
```
CSV okumak için bir Python paketi öner. Yalnızca var olduğundan emin olduklarını yaz; emin değilsen "doğrulanmadı" de.
Her öneri için: standart kütüphane alternatifi, lisans, bakım durumu. Kurulum yapma, yalnız liste ver.
```

## Kontrol soruları
1. Hook neyi yakalamaz? (Regex sınırları, kasıtlı atlatma, yeni kalıplar) — bu yüzden inceleme ve CI gerekir.
2. Sahipsiz zafiyet kaydı neden kabul edilmez? (`.claude/rules/14-zafiyet-takibi.md`)
3. Süresi geçmiş yüksek önemli kayıt varken yeni özellik PR'ı açılır mı?

## İlgili
`docs/adr/0004-hook-tabanli-guvenlik-agi.md` · `.claude/skills/zafiyet-takibi`
