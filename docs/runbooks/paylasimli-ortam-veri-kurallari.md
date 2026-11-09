# Paylaşımlı geliştirme ortamı veri kuralları
(MasterFabric "shared dev data guardrails" pratiğinden uyarlanmıştır.)

## Sahiplik işareti
- Test/tohum kayıtları, tablo destekliyorsa metaveri alanında sahip işareti taşır: `dev:<baş-harfler-veya-github>:<iş-veya-amaç>`.
- Metin alanlarında geçici kayıtlar `[dev:<sahip>]` ile başlar.
- Yalnızca **sentetik** veri; gerçek veri paylaşımlı ortama da girmez.

## Yıkıcı değişiklik politikası
Paylaşımlı ortamda yıkıcı SQL/migrasyon çalıştırmadan önce: (1) planlanan SQL'i ekip kanalına yaz, (2) başka bir geliştiriciden açık onay al, (3) mümkünse yedek/snapshot al.
Yapay zekâ ajanı yıkıcı komut önerirse `command-guard` reddeder; kullanıcı onayı olmadan çalıştırılmaz.

## Temizlik
- En az günlük; varsayılan eskime eşiği 72 saat; tablo destekliyorsa önce soft-delete.
- Temizlik betiği: yalnızca açık ortam değişkeniyle (`ALLOW_SHARED_DEV_CLEANUP=1`), bağlantı bilgisi ve sahip işaretiyle çalışır; "hepsini temizle" modu yalnızca anlaşılmış bakım pencerelerinde.

## Önerilen akış
1. `SHARED_DEV_OWNER_TAG=dev:<kimlik>` ayarla → 2. işaretli veri oluştur → 3. gün sonunda yalnızca kendi işaretini temizle.
