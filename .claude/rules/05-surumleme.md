# Sürümleme
## Web (`apps/web/package.json`) — tek doğruluk kaynağı
Arayüzde görünen sürüm etiketi bu alandan okunur, elle yazılmaz.
| Artış | Ne zaman | Örnek |
|---|---|---|
| PATCH | Düzeltme, metin, stil, küçük bileşen değişikliği | tablo sütunu, a11y düzeltmesi |
| MINOR | **Yeni görünüm** (yeni `page.tsx` / ana rota) | `/raporlar` sayfası |
| MAJOR | Operatörler için uyumsuz değişiklik | ortam değişkeni yeniden adlandırma |
Birden çok değişiklik birlikte gelirse **en yüksek** seviye uygulanır. Yalnızca doküman değişikliği sürüm artırmaz.

## Ajan rehberi sürümü (`AGENTS.md` → `AGENTS_BASE_VERSION`)
Ajanlara yönelik kurallar anlamlı biçimde değişirse aynı commit'te sürüm artırılır:
PATCH yazım/açıklama · MINOR yeni bölüm veya akış · MAJOR zorunlu davranışı kaldıran/uyumsuz değişiklik.

## Genel
`CHANGELOG.md` biçimi: sürüm/tarih başlığı + `### Eklendi / Değişti / Düzeltildi`.

## Karar örnekleri
| Değişiklik | Seviye | Sonuç (0.2.0 → ) |
|---|---|---|
| Tablo sütunu başlığı düzeltildi | PATCH | 0.2.1 |
| Yeni `/raporlar` sayfası (`page.tsx`) | MINOR | 0.3.0 |
| Ortam değişkeni yeniden adlandırıldı | MAJOR | 1.0.0 |
| Sayfa + metin düzeltmesi birlikte | en yüksek = MINOR | 0.3.0 |
| README güncellemesi | artmaz | 0.2.0 |
Artışta alt basamaklar sıfırlanır (MINOR → PATCH=0).

## Do / Don't
- DO: `apps/web/package.json` `version` alanını değiştir; arayüz oradan okur.
- DO: AGENTS.md anlamlı değişince `AGENTS_BASE_VERSION` artır (yazım=PATCH, yeni bölüm=MINOR, zorunlu davranış kaldırma=MAJOR).
- DON'T: sürüm etiketini bileşene sabit yaz. DON'T: yalnızca doküman için sürüm artır.
- CHANGELOG satırı: `- web: ...` / `- api: ...` / `- compute: ...` / `- ai: ...`.
