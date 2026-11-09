---
description: Etkileşimli AI/yazılım eğitimi (docs/egitim ile bağlantılı)
argument-hint: <konu: prompt | claude-code | skill | guvenlik | proje-baslatma>
---
Konu: $ARGUMENTS

## Ne zaman
Personel AI ile çalışmayı öğrenmek istediğinde; ders gibi, kısa uygulamalı.

## Argüman sözdizimi ve varsayılanlar
`/learn <konu>`. Konu → eğitim dosyası:

| Konu | Dosya |
|---|---|
| prompt | `docs/egitim/02-iyi-prompt-ve-brief.md` |
| claude-code | `docs/egitim/03-claude-code-temelleri.md` |
| skill | `docs/egitim/04-skill-rule-command-yazma.md` |
| guvenlik | `docs/egitim/05-guvenli-ai-kullanimi.md`, `08-guvenlik-hook-zafiyet.md` |
| proje-baslatma | `docs/egitim/06-proje-baslatma-akisi.md` (istatistik için `07-istatistik-surec-akisi.md`) |
| (boş) | `01-ai-nedir-ne-degildir.md` ile başla |

Seviye varsayılanı: başlangıç. Kullanıcı sorularına göre ayarla.

## Kullanılan skill/kural
`prompt-yazma` (prompt konusu), `proje-baslat` (proje-baslatma), `ai-risk-degerlendirme` (guvenlik).

## Adımlar
1. İlgili eğitim dosyasını oku; yalnızca oradaki bilgiyi öğret.
2. 5–8 satırda ana fikri anlat.
3. Kısa bir örnek göster (sentetik veri).
4. Kullanıcıya tek, küçük bir görev ver; bekle.
5. Cevabı değerlendir: doğru olanı söyle, bir iyileştirme öner.
6. Seviyeyi ayarla; bir sonraki konuyu öner.

## Çıktı biçimi
`Konu · Ana fikir · Örnek · Görev` ve görev sonrası `Geri bildirim · Sıradaki adım`.

## Örnek
`/learn prompt` → "iyi brief" anlatımı, görev: "şu belirsiz isteği yeniden yaz".
`/learn guvenlik` → hassas veri kuralları, görev: "bu üç içerikten hangisi prompta girebilir?".

## Bitti kontrol listesi
- [ ] Eğitim dosyasına dayandı.
- [ ] Görev verildi ve değerlendirildi.
- [ ] Gerçek veri istenmedi.

## Sık hatalar
- Uzun ders vermek; tek görevle sınırla.
- Görevi vermeden konuyu bitirmek.
