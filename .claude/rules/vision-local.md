---
paths:
  - "agents-local/**"
---
# [FAZ 2] Yerel agent'lar — cihaz-üstü ilkeler
(MasterFabric Mac CLI gizlilik pratiğinden uyarlanmıştır.)
- Hassas girdi ve model çıktıları cihazdan **çıkmaz**; telemetri yok.
- Yapılandırma ve kimlik bilgileri repo dışında kullanıcı dizininde tutulur (ör. `~/.config/<uygulama>/config.toml`), repoya yalnızca `*.example` girer.
- Günlüklere ham görüntü, kişisel veri ve sır yazılmaz.
- Ayrıcalıklı işlemler (sürücü, servis kurulumu) için açık kullanıcı onayı iste; değişiklikleri tutucu tut.
- Kullanıcıya dönük metinde sistemi **deneysel** olarak etiketle; sonuçlar insan doğrulaması gerektirir.
- Değerlendirme setleri (`evals/`) yalnızca sentetik/anonim görüntü içerir.
