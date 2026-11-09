# Paylaşımlı geliştirme ortamı veri kuralları
(MasterFabric "shared dev data guardrails" pratiğinden uyarlanmıştır.)

## Ne zaman
Birden fazla kişinin kullandığı geliştirme/test veritabanı veya ortamı varsa. Yalnızca **sentetik** veri; gerçek veri paylaşımlı ortama da girmez.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Sahip işareti | `dev:<baş-harfler-veya-github>:<iş-veya-amaç>` |
| Eskime eşiği | 72 saat (parametre; ekip kararı) |
| Temizlik sıklığı | günlük |
| Silme biçimi | tablo destekliyorsa önce soft-delete |

## Sahiplik işareti
- Test/tohum kayıtları, tablo destekliyorsa metaveri alanında sahip işareti taşır.
- Metin alanlarında geçici kayıtlar `[dev:<sahip>]` ile başlar.
- Örnek: `dev:gfg:seri-testi`, metin: `[dev:gfg] deneme gösterge`.

## Yıkıcı değişiklik politikası
Paylaşımlı ortamda yıkıcı SQL/migrasyon (DROP, TRUNCATE, koşulsuz DELETE/UPDATE) çalıştırmadan önce:
1. Planlanan SQL'i ekip kanalına yaz.
2. Başka bir geliştiriciden **açık onay** al.
3. Mümkünse yedek/snapshot al.
Yapay zekâ ajanı yıkıcı komut önerirse `command-guard` reddeder; kullanıcı onayı olmadan çalıştırılmaz.

## Temizlik
- Betik yalnızca açık ortam değişkeniyle (`ALLOW_SHARED_DEV_CLEANUP=1`), bağlantı bilgisi ve sahip işaretiyle çalışır.
- "Hepsini temizle" modu yalnızca anlaşılmış bakım pencerelerinde.
- Bağlantı bilgisi komut satırına/loga yazılmaz; ortam değişkeninden okunur.

## Adımlar (önerilen akış)
1. `SHARED_DEV_OWNER_TAG=dev:<kimlik>` ayarla.
2. İşaretli sentetik veri oluştur.
3. Gün sonunda yalnızca **kendi** işaretini temizle (önce kuru çalıştırma/listeleme).
4. Bir kayıt başkasına aitse veya işaretsizse dokunma; ekip kanalında sor.

## Bitti kontrol listesi
- [ ] Tüm kayıtlarım işaretli · [ ] Gerçek veri yok · [ ] Temizlik yalnız kendi işaretime uygulandı · [ ] Yıkıcı işlem onaylı

## Sık hatalar
- İşaretsiz kayıt oluşturmak (sahibi bulunamaz, temizlenemez).
- Temizlik betiğini koşulsuz çalıştırmak.
- Gerçek veriyi "geçici" diye yüklemek.

## İlgili
`.claude/rules/01-veri-gizliligi.md` · `docs/adr/0004-hook-tabanli-guvenlik-agi.md`
