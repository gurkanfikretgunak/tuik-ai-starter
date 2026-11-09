# Katkı rehberi: skill, rule, command ekleme

## Ne eklenecek?
| Ne | Ne zaman | Nerede |
|---|---|---|
| **Rule** | Her zaman uyulacak kural | `.claude/rules/<ad>.md` (`paths:` ile kapsam daralt) |
| **Skill** | Belirli işte yüklenen uzmanlık | `.claude/skills/<ad>/SKILL.md` |
| **Command** | Kullanıcının tetiklediği akış | `.claude/commands/<ad>.md` |
| **Agent** | Ayrı bağlamda çalışan uzman | `.claude/agents/<ad>.md` |
| **Hook** | Otomatik güvenlik/biçim kontrolü | `.claude/hooks/` + `settings.json` |
Karar sırası: otomatik uygulanmalı mı → hook; hep geçerli mi → rule; belirli iş mi → skill; kullanıcı mı tetikleyecek → command.

## Boyut hedefleri (yerel/küçük modeller için kısa tut)
Skill ≈ 80–200 satır · command ≈ 30–80 · agent ≈ 30–70 · rule ≈ 20–60. Önemli bilgi dosyanın başında.

## Skill yazma
1. `description` alanı "ne zaman kullanılır"ı açıkça söylemeli (tek satır, ≤ 300 karakter).
2. SKILL.md kısa kalsın (adımlar + kontrol listesi); uzun referanslar `references/` altına.
3. Kendi kendine yeten olsun: gerçek yol ve komutları yaz, uydurma yok.
4. Gerçek bir görevle dene; çıktı beklediğin gibi değilse description ve adımları iyileştir.
5. PR'da örnek kullanım ekle.

### Başlık iskeleti
`## Ne zaman` · `## Girdiler ve varsayılanlar` · `## Adımlar` · `## Şablon` · `## Örnek` · `## Bitti kontrol listesi` · `## Sık hatalar` · `## İlgili`

### Command iskeleti
```markdown
---
description: <tek cümle>
argument-hint: <argüman>
---
Girdi: $ARGUMENTS
1. ...
```

## Kontrol listesi
- [ ] Veri gizliliği kurallarına aykırı bir şey yok
- [ ] Örnekler sentetik veriyle
- [ ] Türkçe, sade ve kısa; kod/değişken İngilizce
- [ ] Kurumsal eşik/yöntem koda gömülmedi (parametre)
- [ ] `make sync-cursor` çalıştırıldı (`.cursor/` elle düzenlenmez)

## Hook ekleme
`.claude/hooks/` altına betik + `settings.json` kaydı + `scripts/test-hooks.sh` testi + `.claude/hooks/README.md` tablosu. Yanlış pozitifleri düşün; hook'lar atlatılamaz güvenlik değil, ilk savunma hattıdır. Çalıştır: `make test-hooks`.

## PR akışı
Commit biçimi `tip(kapsam): açıklama` (örn. `feat(ai): yeni skill eklendi`). Ayrıntı: `.claude/rules/03-commit-ve-pr.md`, `CONTRIBUTING.md`. Ajan kuralları anlamlı değişirse `AGENTS.md` içindeki `AGENTS_BASE_VERSION` artırılır (`.claude/rules/05-surumleme.md`).

## Sık hatalar
- Belirsiz `description` (skill hiç tetiklenmez) · gerçek veri içeren örnek · `.cursor/` elle düzenleme · testsiz hook.
