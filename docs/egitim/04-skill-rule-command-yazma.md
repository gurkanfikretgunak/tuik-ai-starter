# 4. Skill, rule, command yazma
**Seviye:** Orta · **Süre:** 45 dk

## Öğrenme hedefi
Doğru ayar türünü seçmek ve küçük bir skill'i şablonla yazıp gerçek görevle denemek.

## Hangisi ne zaman?
| Tür | Tanım | Yer |
|---|---|---|
| Rule | Her zaman uyulacak kural | `.claude/rules/<ad>.md` |
| Skill | Gerektiğinde yüklenen uzmanlık | `.claude/skills/<ad>/SKILL.md` |
| Command | Sizin tetiklediğiniz akış | `.claude/commands/<ad>.md` |
| Agent | Ayrı bağlamda çalışan uzman | `.claude/agents/<ad>.md` |
| Hook | Otomatik uygulatma | `.claude/hooks/` |
Karar: "Hep geçerli mi?" → rule. "Belirli işte mi?" → skill. "Ben tetikleyeceğim" → command.

## Skill iskeleti (kopyala)
```markdown
---
name: birim-ozel-ornek
description: <Ne yapar>. <Ne zaman kullanılır — tetikleyici ifadeler>. (tek satır, ≤ 300 karakter)
---
## Ne zaman
## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
## Adımlar
1. ...
## Örnek
Girdi -> beklenen çıktı (sentetik)
## Bitti kontrol listesi
- [ ] ...
## Sık hatalar
```

## Adım adım alıştırma
1. `.claude/skills/kvkk-kontrol/SKILL.md` ve `.claude/skills/turkce-arama/SKILL.md` dosyalarını okuyup yapıyı karşılaştırın.
2. `.claude/skills/birim-ozel-ornek/SKILL.md` oluşturun (yukarıdaki iskelet; birimine özgü küçük bir iş).
3. Gerçek bir görevle deneyin; çıktı beklediğiniz gibi değilse `description` ve adımları düzeltin.
4. `make sync-cursor` ile `.cursor/` eşitlenir (elle düzenlemeyin).
5. PR açın (`.claude/rules/03-commit-ve-pr.md`; örn. `feat(ai): birim ozel skill eklendi`).

## Kötü → iyi `description`
- Kötü: `İstatistik yardımcı.`
- İyi: `Anket ağırlıklarından ağırlıklı ortalama ve CV hesaplar. Tahmin ve doğruluk göstergesi gereken işlerde kullan.`

## Kontrol soruları
1. Her zaman geçerli bir güvenlik kuralı rule mu skill mi olmalı?
2. `description` zayıfsa ne olur? (skill tetiklenmez)
3. Neden örnekler sentetik veriyle yazılır?

## İlgili
`docs/katki-rehberi.md` · `CONTRIBUTING.md`
