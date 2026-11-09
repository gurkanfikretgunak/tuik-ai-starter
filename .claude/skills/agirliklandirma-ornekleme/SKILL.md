---
name: agirliklandirma-ornekleme
description: Örneklem ağırlıkları, ağırlıklı ortalama/toplam ve değişim katsayısı (CV) gibi tahmin ve doğruluk hesaplarını yazar. Anket tahmini ve doğruluk göstergesi gereken işlerde kullan.
---
# Ağırlıklandırma ve doğruluk
- Ağırlıklı ortalama: `Σ(w·y) / Σ(w)`; ağırlık ≤ 0 veya NaN ise açık hata.
- Ağırlıklı toplam: `Σ(w·y)`.
- Doğruluk: standart hata ve **değişim katsayısı CV = SE / tahmin × 100**. CV'yi tabloyla birlikte raporla; eşik değerleri (ör. "güvenilir değil" işareti) **kurum kararıdır**, kodda sabitlenmez, yapılandırmadan gelir.
- Ağırlık ayarları (kalibrasyon, yanıtsızlık düzeltmesi) yöntem belgesine yazılır; kodda formül kaynağı docstring'dedir.
- Uygulama: `compute/src/tuik_calc/weights.py` (testli). Karmaşık varyans tahmini (tabakalı/kümeli) için doğrulanmış istatistik kütüphanesi kullan; elle yazma.
