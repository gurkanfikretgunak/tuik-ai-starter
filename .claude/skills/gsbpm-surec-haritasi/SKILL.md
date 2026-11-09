---
name: gsbpm-surec-haritasi
description: Bir işi istatistik üretim sürecinin (GSBPM) aşamalarına eşler ve her aşama için çıktı, kontrol ve sorumlu araç önerir. Yeni istatistik/gösterge/anket projesi planlanırken veya "bu iş sürecin neresinde" sorulduğunda kullan.
---
# GSBPM süreç haritası
Genel İstatistiksel İş Süreci Modeli (GSBPM) aşamaları: **1 İhtiyaç belirleme → 2 Tasarım → 3 Yapılandırma → 4 Veri toplama → 5 İşleme → 6 Analiz → 7 Yayım → 8 Değerlendirme**.

Her görev için şu tabloyu doldur:
| Aşama | Bu işte ne yapılıyor | Çıktı | Kontrol | Skill |
|---|---|---|---|---|
| 1 İhtiyaç | kullanıcı/gösterge ihtiyacı | PRD | kapsam netliği | `proje-baslat` |
| 2 Tasarım | kavram, sınıflama, örneklem, metaveri | gösterge tanımı | tanım tutarlılığı | `istatistik-gostergesi`, `siniflandirma-esleme` |
| 3 Yapılandırma | araç/kod/boru hattı | çalışan iskelet + test | testler yeşil | `go-api-endpoint`, `py-hesaplama-modulu` |
| 4 Toplama | veri alımı/adaptör | ham veri (değişmez) | şema doğrulama | `veri-adaptoru` |
| 5 İşleme | temizleme, düzeltme, kodlama, ağırlık | işlenmiş veri | doğrulama kuralları | `veri-temizleme`, `agirliklandirma-ornekleme` |
| 6 Analiz | tahmin, endeks, mevsimsel düzeltme | sonuç tabloları | bağımsız yeniden hesap | `endeks-hesaplama`, `kalite-raporu` |
| 7 Yayım | tablo/grafik/API, ifşa kontrolü | yayın seti | ifşa + embargo | `ifsa-kontrolu`, `yayin-ve-revizyon`, `veri-gorsellestirme` |
| 8 Değerlendirme | kalite raporu, geri bildirim | kalite raporu | ölçütler | `kalite-raporu` |

Kurallar: `.claude/rules/08-istatistik-surec.md`. Not: GSBPM ortak bir referans modeldir; kurumun kendi süreç tanımı varsa o esas alınır.
