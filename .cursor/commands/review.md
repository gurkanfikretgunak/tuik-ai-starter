Argüman almaz. Çalışma ağacındaki değişiklikleri inceler; kod yazmaz.

## Ne zaman
Commit/PR öncesi veya bir özellik bittikten sonra.

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| Kapsam | `git diff` + `git diff --staged` |
| Fark boşsa | `git diff main...HEAD` |
| Sıra | Veri gizliliği > güvenlik > doğruluk > test > okunabilirlik |

## Kullanılan skill/agent
Agent: `reviewer`; skill: `kod-inceleme`; veri içerik şüphesinde `kvkk-kontrol` / `data-privacy-auditor`. Kurallar: `.claude/rules/01`, `02`, `test.md`.

## Adımlar
1. Değişen dosyaları listele (`git status`, `git diff --stat`).
2. `reviewer` agent'ını `kod-inceleme` listesiyle çalıştır.
3. Hassas veri/sır belirtisi varsa en üste koy (değeri maskele).
4. Bulguları Kritik / Önemli / Öneri olarak sırala; her biri `dosya:satır` + somut düzeltme.
5. Testler eksikse belirt (başarılı + hata yolu).
6. Sonuç: "Birleştirilebilir" veya "Düzeltme gerekli".

## Çıktı biçimi
```
Karar: ...
Kritik: 1) dosya:satır — sorun — düzeltme
Önemli: ...
Öneri: ...
```

## Örnek
`/review` → 1 Kritik (ham değer loga yazılıyor), 2 Önemli (hata yolu testi yok), karar: Düzeltme gerekli.

## Bitti kontrol listesi
- [ ] Tüm değişen dosyalar tarandı.
- [ ] Her bulguda konum + düzeltme var.
- [ ] Hassas veri bulguları maskelendi.

## Sık hatalar
- Sadece stil bulguları yazıp güvenliği atlamak.
- Bulguyu kanıtsız yazmak (satırı doğrula).
