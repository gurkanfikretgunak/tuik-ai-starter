---
name: zafiyet-takibi
description: Bağımlılık ve kod zafiyetlerini tarar, kayıt defterine işler, önceliklendirir ve düzeltme akışını yönetir. Bağımlılık ekleme/güncelleme, güvenlik taraması veya zafiyet bildirimi sonrası kullan.
---
# Zafiyet takibi
1. **Tara:** `make audit` (npm audit · pip-audit · govulncheck; kurulu olmayanı atlar). Hook bulguları: `make audit-list`.
2. **Önceliklendir:** önem (Kritik/Yüksek/Orta/Düşük) + erişilebilirlik (bu kod yolu gerçekten çağrılıyor mu?) + düzeltme var mı?
3. **Kaydet:** `docs/security/zafiyet-kayitlari.md` — ID, kaynak, bileşen, önem, sorumlu, hedef tarih. Elle: `python3 scripts/vuln-track.py add --kaynak ... --bilesen ... --ozet ... --onem Yüksek --sorumlu ekip`.
4. **Düzelt:** en küçük güvenli güncelleme; testleri çalıştır; PR açıklamasında kayıt ID'sini an.
5. **Kapat:** durum `Düzeltildi` (veya gerekçeli `Kabul edildi (risk)` / `Yanlış pozitif`).
Not: tarama araçlarının bulgusu kesin değildir; yanlış pozitif olabilir. Yapay zekâ önerdiği düzeltmeyi de test et.
