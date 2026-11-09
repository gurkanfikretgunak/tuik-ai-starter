---
description: Next.js'e yeni sayfa veya bileşen ekle
argument-hint: <sayfa/bileşen açıklaması>
---
İstek: $ARGUMENTS

## Ne zaman
`apps/web` içine yeni rota (`page.tsx`) veya yeniden kullanılabilir bileşen eklerken.

## Argüman sözdizimi ve varsayılanlar
`/new-page <açıklama>` — örn. `/new-page /raporlar sayfası, seri tablosu ve çizgi grafik`.

| Eksik girdi | Varsayım |
|---|---|
| Yönlendirme | App Router: `apps/web/src/app/<rota>/page.tsx` (mevcut yapıyı doğrula) |
| Dil | Arayüz TR (EN yalnızca proje istiyorsa) |
| Veri | Sözleşmeye uygun API; yoksa sentetik örnek |
| Erişilebilirlik | Anlamlı başlıklar, etiketli form, klavye erişimi |
| Grafik | Gerekirse `veri-gorsellestirme` |

## Kullanılan skill/kural
`nextjs-sayfa-bilesen` (ana), `veri-gorsellestirme` (grafik), `turkce-arama` (arama/süzme), `tasarim-dokumani` (tema kararı). Kurallar: `.claude/rules/web-nextjs.md`, `04-ship-checklist.md`, `05-surumleme.md`.

## Adımlar
1. `apps/web/src` yapısına ve `apps/web/CLAUDE.md` kurallarına bak; benzer sayfayı örnek al.
2. API gerekiyorsa sözleşmeye uygun çağrı yaz (gerekirse `/regenerate-client`).
3. Sayfayı/bileşeni yaz: TypeScript, TR metin, erişilebilir.
4. Yükleniyor, boş ve hata durumlarını ekle.
5. Vitest testi yaz: başarılı render + hata durumu.
6. `cd apps/web && npm test && npm run lint`.
7. `apps/web/package.json` sürümünü artır: yeni rota = MINOR, küçük düzeltme = PATCH.
8. `CHANGELOG.md` içine `web:` notu.

## Çıktı biçimi
Eklenen dosyalar, sürüm artışı, test sonucu, ekran/rota yolu.

## Örnek
`/new-page /seriler tablo ve il araması` → `seriler/page.tsx`, Türkçe karakter duyarsız arama, MINOR sürüm.

## Bitti kontrol listesi
- [ ] Metinler TR; erişilebilirlik kontrol edildi.
- [ ] Boş/hata/yükleniyor durumları var.
- [ ] Test geçiyor; sürüm ve CHANGELOG güncel.
- [ ] Gerçek veri veya sır yok.

## Sık hatalar
- API adresini koda gömmek (ortam değişkeni kullan).
- Sürümü artırmayı unutmak.
- Arayüzde `toLowerCase` ile Türkçe İ/ı hatası (`turkce-arama` kullan).
