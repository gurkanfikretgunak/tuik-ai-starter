---
name: prompt-serisi
description: Büyük bir uygulamayı sıralı, numaralı promptlarla (prompt1…N) adım adım inşa etme yöntemi. Sıfırdan uygulama kurarken ve eğitimde "AI ile proje nasıl büyütülür" gösterilirken kullan.
---
# Prompt serisi yöntemi
(`_meta-sicil` çalışmasından uyarlanmıştır.)
1. **Prompt 1 — Kurulum ve veri katmanı:** çalışma dizini, yığın, tip tanımı, veri adaptörü, **sentetik** veri üretici (seed'li).
2. **Prompt 2 — Çekirdek özellik:** arama/liste, sunucu tarafı indeks.
3. **Prompt 3 — Detay ekranı:** kimlik çipleri, durum rozetleri.
4. **Prompt 4 — Tasarım cilası:** `DESIGN.md` ile uyum, boş/hata durumları.
5. **Prompt 5 — Erişilebilirlik ve test.**
6. **Prompt 6 — Doküman, README, örnek veri uyarısı.**
Her prompt: **Bağlam** (dizin, önceki çıktı) → **Hedef** → **Kısıtlar** (yığın, sentetik veri, Türkçe arayüz) → **Kabul ölçütü** (komut ve beklenen sonuç).
Her adımdan sonra: çalıştır, test et, `git commit`; çıktıyı bir sonraki prompta bağlam olarak ver. Hata günlüğünü (`run*.log`) repoya değil `.claude/logs/` benzeri yerel klasöre koy.
Örnek: `examples/05-prompt-serisi/`.
