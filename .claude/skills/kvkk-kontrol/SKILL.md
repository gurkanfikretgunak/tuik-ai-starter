---
name: kvkk-kontrol
description: Değişikliklerde kişisel veri, gizli istatistiki bilgi ve sır sızıntısı kontrolü. Commit/PR öncesi ve veri içeren her işte kullan.
---
# Veri/PII kontrolü
Tara: TC kimlik no (11 hane), telefon, e-posta, IBAN, adres, birim düzeyi kayıtlar, anahtar/token/parola kalıpları, `.env`, büyük CSV/parquet dosyaları.
Betik: `.claude/skills/kvkk-kontrol/scan.sh`
Bulguyu **maskeleyerek** raporla (ilk/son 2 karakter). Küçük hücre (az sayıda birim içeren kırılım) riski varsa ayrıca uyar.
