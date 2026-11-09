---
name: agirliklandirma-ornekleme
description: Örneklem ağırlıkları, ağırlıklı ortalama/toplam ve değişim katsayısı (CV) hesaplarını weights.py ile yazar. Anket tahmini ve doğruluk göstergesi gereken işlerde kullan.
---
# Ağırlıklandırma ve doğruluk (GSBPM 5–6)

## Ne zaman
Anket/örneklem tahmini (toplam, ortalama) ve doğruluk göstergesi (CV) gerektiğinde.

## Girdiler ve varsayılanlar
| Girdi | Eksikse varsayım |
|---|---|
| `values` | sayısal liste; eksik değer **önce işlenir** (fonksiyon hata verir) |
| `weights` | tasarım ağırlığı = 1/seçim olasılığı; pozitif, NaN olmayan |
| Standart hata | dışarıdan gelir; basit varyans formülü uydurma |
| CV eşikleri ("güvenilir değil" vb.) | **parametre; kurum kararı**, yapılandırmadan |
| Kalibrasyon/yanıtsızlık düzeltmesi | yöntem belgesinde; burada uygulanmış ağırlık gelir |

## Formüller (standart tanım)
- Ağırlıklı toplam: `Ŷ = Σ wᵢ·yᵢ`
- Ağırlıklı ortalama: `ȳ_w = Σ wᵢ·yᵢ / Σ wᵢ`
- Değişim katsayısı: `CV = SE(θ̂) / |θ̂| × 100` (%)
- Tasarım ağırlığı: `wᵢ = 1/πᵢ` (πᵢ seçim olasılığı); yanıtsızlık düzeltmesi: `w* = w / yanıt oranı` (tabaka içinde)

## Fonksiyonlar (`compute/src/tuik_calc/weights.py`)
| İmza | Davranış |
|---|---|
| `weighted_total(values, weights) -> float` | Σ(w·y) |
| `weighted_mean(values, weights) -> float` | Σ(w·y)/Σ(w) |
| `coefficient_of_variation(standard_error, estimate) -> float` | SE/\|tahmin\|×100; tahmin 0 → `ValueError`; SE<0 → `ValueError` |
`ValueError`: uzunluklar farklı, boş girdi, ağırlık ≤0/NaN, eksik değer.

## Adımlar
1. Veriyi `veri-temizleme` ile doğrula; eksikleri çıkar/doldur kararını yaz.
2. Ağırlıkları kontrol et: `len(values)==len(weights)`, hepsi > 0; Σw'yi (kitle tahmini) bilinen kitleyle karşılaştır.
3. Tahmini `weighted_total` / `weighted_mean` ile hesapla (tabaka/alan grubu bazında döngüyle).
4. SE'yi doğrulanmış istatistik kütüphanesi veya onaylı yöntemle hesapla (tabakalı/kümeli tasarımda elle yazma; kütüphane adını **doğrula**, uydurma).
5. `coefficient_of_variation(se, tahmin)`; CV'yi tahminin yanında raporla.
6. Eşik karşılaştırmasını yapılandırma değerinden yap; kod içinde sabit yok.
7. Küçük hücre için `ifsa-kontrolu`; CV özetini `kalite-raporu`'na yaz.
8. Test: elle hesap, `pytest.approx`, hata yolu (boş, NaN, w≤0).

## Şablon
```python
from tuik_calc.weights import weighted_total, weighted_mean, coefficient_of_variation

y = [10.0, 20.0, 30.0]; w = [1.0, 3.0, 2.0]
total = weighted_total(y, w)          # 130.0
mean = weighted_mean(y, w)            # 130/6 = 21.666...
cv = coefficient_of_variation(standard_error=SE, estimate=mean)  # SE dış kaynaktan
flag = cv > CV_ESIK                   # CV_ESIK yapılandırmadan (kurum kararı)
```

## Örnek
`weighted_mean([10, 20], [1, 3])` → `17.5` · `weighted_total([1, 2, 3], [10, 10, 10])` → `60.0` · `coefficient_of_variation(2.0, 40.0)` → `5.0` · `weighted_mean([1], [0])` → `ValueError`.

## Bitti kontrol listesi
- [ ] Elle hesap + `pytest.approx` testi; hata yolu testi var.
- [ ] Ağırlık kaynağı ve ayarları (kalibrasyon, yanıtsızlık) yöntem notunda.
- [ ] CV tahminle birlikte raporlandı; eşik yapılandırmada.
- [ ] Eksik değer kararı (çıkar/doldur) ve oranı yazıldı.
- [ ] Sentetik veri.

## Sık hatalar
- Ağırlıksız ortalamayı ağırlıklı yerine kullanmak.
- Eksik değeri 0 yapıp ağırlıklamak.
- Tahmin 0 iken CV hesaplamaya çalışmak.
- CV eşiğini koda gömmek.
- Karmaşık tasarımda SE'yi basit formülle hesaplamak.

## İlgili
`compute/src/tuik_calc/weights.py` · `compute/tests/test_weights.py` · `.claude/rules/09-kalite-ve-dogrulama.md` · skill: `veri-temizleme`, `kalite-raporu`, `ifsa-kontrolu`.
