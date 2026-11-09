# Katkı rehberi: skill, rule, command ekleme

| Ne | Ne zaman | Nerede |
|---|---|---|
| **Rule** | Her zaman uyulacak kural | `.claude/rules/<ad>.md` (`paths:` ile kapsam daralt) |
| **Skill** | Belirli işte yüklenen uzmanlık | `.claude/skills/<ad>/SKILL.md` |
| **Command** | Kullanıcının tetiklediği akış | `.claude/commands/<ad>.md` |
| **Agent** | Ayrı bağlamda çalışan uzman | `.claude/agents/<ad>.md` |
| **Hook** | Otomatik güvenlik/biçim kontrolü | `.claude/hooks/` + `settings.json` |

## Skill yazma
1. `description` alanı "ne zaman kullanılır"ı açıkça söylemeli.
2. SKILL.md kısa kalsın (adımlar + kontrol listesi); uzun referanslar `references/` altına.
3. Gerçek bir görevle dene; çıktı beklediğin gibi değilse description ve adımları iyileştir.
4. PR'da örnek kullanım ekle.

## Kontrol listesi
- [ ] Veri gizliliği kurallarına aykırı bir şey yok
- [ ] Örnekler sentetik veriyle
- [ ] Türkçe, sade ve kısa

## Hook ekleme
`.claude/hooks/` altına betik + `settings.json` kaydı + `scripts/test-hooks.sh` testi + `.claude/hooks/README.md` tablosu. Yanlış pozitifleri düşün; hook'lar atlatılamaz güvenlik değil, ilk savunma hattıdır.
