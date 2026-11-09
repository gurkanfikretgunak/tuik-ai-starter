---
description: Bir istatistik işini GSBPM aşamalarına eşleyip adım adım yürüt
argument-hint: <gösterge/anket/hesaplama tanımı>
---
İş: $ARGUMENTS

## Ne zaman
Yeni gösterge, anket veya hesaplama işi başlarken; "bu iş sürecin neresinde?" sorusunda.

## Argüman sözdizimi ve varsayılanlar
`/new-surec <iş tanımı>` — örn. `/new-surec aylık fiyat endeksi hesaplama`.

| Eksik girdi | Varsayım |
|---|---|
| Veri sınıfı | Hassas olabilir → `ai-risk-degerlendirme` çalıştır |
| Periyot | Aylık |
| Kapsam | Hesaplama + yayım hazırlığı |
| Eşikler/yöntem | Parametre; kurum kararı (kodda sabitleme) |

## Kullanılan skill/kural
`gsbpm-surec-haritasi` (ana). Aşamaya göre: `istatistik-gostergesi`, `veri-temizleme`, `agirliklandirma-ornekleme`, `endeks-hesaplama`, `siniflandirma-esleme`, `ifsa-kontrolu`, `kalite-raporu`, `yayin-ve-revizyon`. Kurallar: `.claude/rules/08-istatistik-surec.md`, `09`–`12`.

## Adımlar
1. `gsbpm-surec-haritasi` ile işi aşamalara eşle; tablo: aşama, çıktı, kontrol, skill, repo yolu.
2. Veri sınıfını belirle; hassassa `/ai-risk`.
3. Hangi aşamada hangi skill/kural devreye girer, yaz; plan çıkar, **onay iste**.
4. Uygula: tasarım (gösterge/metaveri) → yapılandırma → işleme → analiz; her aşamada doğrulama ve test.
5. Yayım öncesi `/ifsa-kontrol` ve `/kalite-kontrol`; yayın takvimi/revizyon için `yayin-ve-revizyon`.
6. Sonucu aşama bazlı özetle.

## Çıktı biçimi
```
| GSBPM aşaması | Çıktı | Skill/araç | Durum |
```
+ plan, riskler, açık kararlar (kurum).

## Örnek
`/new-surec konut fiyat endeksi` → tablo, plan, onay sonrası `endeks-hesaplama` ile hesap, ardından ifşa ve kalite kontrolü.

## Bitti kontrol listesi
- [ ] Aşama tablosu üretildi.
- [ ] Veri sınıfı belirlendi.
- [ ] Her aşamada doğrulama yapıldı.
- [ ] Yayım öncesi ifşa + kalite kontrolü geçti.

## Sık hatalar
- Aşamayı atlayıp doğrudan hesaplamaya geçmek.
- Kurum eşiklerini uydurmak.
