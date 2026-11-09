---
name: yayin-ve-revizyon
description: Yayın takvimi, embargo, geçici/kesin durum işaretleri ve revizyon yönetimi. Veri yayımlamadan, API'den seri sunmadan veya revizyon yapmadan önce kullan.
---
# Yayım ve revizyon (GSBPM 7)
- **Takvim:** yayın zamanı önceden ilan edilir; kod içinde sabit tarih yok, yapılandırma/takvim dosyasından gelir.
- **Embargo:** yayın anından önce veri herkese açık yola (API, statik dosya, önbellek, günlük) düşmemeli. Yayın bayrağı ve zaman damgası kontrol edilir.
- **Durum bayrakları:** her gözlem için `durum` (`geçici`, `kesin`, `revize`, `gizli`, `tahmini`) ve sözleşmede alanı bulunur.
- **Revizyon:** önceki değer saklanır, revizyon tarihi/nedeni yazılır; revizyon politikası göstergenin metaverisindedir. Büyük revizyonlar kalite raporuna girer.
- **Seri kırılması:** yöntem/sınıflama değişikliklerinde işaretlenir.
- Yayından önce sırayla: doğrulama → `ifsa-kontrolu` → kalite raporu → yayım bayrağı.
