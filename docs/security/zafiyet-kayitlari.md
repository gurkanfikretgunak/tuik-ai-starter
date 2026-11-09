# Zafiyet kayıtları

Bağımlılık taramaları, kod incelemesi ve hook uyarılarından gelen zafiyetlerin **tek takip yeri**.
Satırları elle veya `python3 scripts/vuln-track.py add ...` / `make audit` ile ekleyin. `ORNEK-*` satırları örnektir, sayılmaz.

**Önem düzeyleri:** Kritik · Yüksek · Orta · Düşük
**Durumlar:** Açık · İnceleniyor · Düzeltildi · Kabul edildi (risk) · Yanlış pozitif
**Örnek hedef süreler (kurum politikası geçerlidir):** Kritik 7 gün · Yüksek 30 gün · Orta 90 gün · Düşük bir sonraki sürüm.

| ID | Tarih | Kaynak | Bileşen | Özet | Önem | Durum | Sorumlu | Hedef tarih | Not |
|---|---|---|---|---|---|---|---|---|---|
| ORNEK-001 | 2026-11-09 | npm audit | next@15.0.0 | Örnek: istek sahteciliği zafiyeti (GHSA-xxxx) | Yüksek | Açık | web-ekibi | 2026-12-09 | `npm update next` ve testleri çalıştır |
| ORNEK-002 | 2026-11-09 | kod incelemesi | services/api | Örnek: giriş doğrulaması eksik uç nokta | Orta | İnceleniyor | api-ekibi | 2027-02-07 | OpenAPI şemasına sınır eklenecek |
| ORNEK-003 | 2026-11-09 | hook (post-write-scan) | compute | Örnek: `shell=True` kullanımı | Orta | Düzeltildi | compute-ekibi | - | argüman listesine çevrildi |
