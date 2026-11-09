# 3. Claude Code temelleri
**Seviye:** Başlangıç · **Süre:** 40 dk

## Öğrenme hedefi
Repoda Claude Code'u açıp **plan → onay → uygulama → doğrulama** döngüsünü uygulamak; slash komutlarını ve diff incelemeyi kullanmak.

## Ön koşul
`make doctor` çıktısında `git`, `node`, `npm`, `go`, `python3`, `make` için `OK` görün.

## Komutlar (`.claude/commands/`)
| Komut | Ne yapar |
|---|---|
| `/new-project` | Şablondan yeni proje (fikir → PRD → iskelet) |
| `/new-feature` | Plan → kod → test akışı |
| `/new-page`, `/new-endpoint`, `/new-calc` | Web sayfası, Go endpoint, Python hesaplama |
| `/review` | Mevcut değişikliği incele |
| `/ship` | Test + lint + commit + PR hazırlığı |
| `/learn <konu>` | Etkileşimli eğitim |

## Adım adım alıştırma (`examples/01-ilk-prompt-ile-sayfa`)
1. Repo kökünde `claude` çalıştırın.
2. Plan isteyin: `Önce plan: data/sample/ornek_seri.csv verisini bölgeye göre çizgi grafikle gösteren sayfa. Kod yazma.`
3. Planı okuyun; dosya listesi ve test adımı yoksa ekletin. Onaylayın.
4. Uygulatın: `/new-page Bölgelere göre aylık seriyi çizgi grafikle gösteren sayfa. Veri: data/sample/ornek_seri.csv. Türkçe etiketler, erişilebilir renkler, test dahil.`
5. `git status` ve `git diff` ile **her dosyayı** okuyun.
6. `cd apps/web && npm test` çalıştırın; yeşil olmadan bitmiş saymayın.
7. `/review` ile ikinci göz isteyin.

## Kötü → iyi
| Kötü | İyi |
|---|---|
| "Sayfayı yap ve commit'le." | "Önce plan ver; onayımdan sonra kodla; testler yeşilse özetle, commit'i ben yaparım." |
| Diff'e bakmadan kabul | Dosya dosya incele, istemediğin değişikliği geri aldır |

## Güvenlik ağı
Hook'lar komutları ve dosya erişimini denetler (`.claude/hooks/README.md`). Engel görürseniz atlatmayın; mesajı okuyup isteği değiştirin.

## Kontrol soruları
1. Plan aşamasını atlamak hangi riski doğurur?
2. `git diff`'te neye bakarsınız? (kapsam dışı dosya, sır, silinen test)
3. Test yeşil ama sayfa yanlışsa hangi test eksik demektir?

## İlgili
`02-iyi-prompt-ve-brief.md` · `06-proje-baslatma-akisi.md`
