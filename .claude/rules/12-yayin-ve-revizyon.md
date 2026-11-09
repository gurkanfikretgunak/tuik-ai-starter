---
paths:
  - "services/**"
  - "apps/web/**"
  - "compute/**"
---
# Yayım ve revizyon
- Yayın zamanı takvimden/yapılandırmadan gelir; yayın anından önce veri herkese açık hiçbir yola (API, statik dosya, önbellek, log) düşmez (embargo).
- Her gözlemde `durum` alanı: `geçici`, `kesin`, `revize`, `gizli`, `tahmini`.
- Revizyonda önceki değer ve revizyon nedeni saklanır; yöntem değişikliği seri kırılması olarak işaretlenir (`yayin-ve-revizyon` skill'i).
- Yayından önce sıra: doğrulama → ifşa kontrolü → kalite raporu → yayım bayrağı.
