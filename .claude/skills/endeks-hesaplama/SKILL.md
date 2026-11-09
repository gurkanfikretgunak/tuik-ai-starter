---
name: endeks-hesaplama
description: Fiyat/miktar endeksleri (zincirleme, Laspeyres, ağırlıklı bileşik), taban değişimi ve yüzde değişim hesaplar (indices.py). Endeks ve değişim oranı işlerinde kullan; mevsimsel düzeltme için onaylı araca yönlendirir.
---
# Endeks hesaplama (GSBPM 6)

## Ne zaman
Yüzde değişim, zincirleme endeks, bileşik (ağırlıklı) endeks, taban değişimi, dönem karşılaştırması.

## Girdiler ve varsayılanlar
| Girdi | Eksikse varsayım |
|---|---|
| Taban değer | `100.0`; taban dönemi yazılı olmalı (örn. `2015=100`) |
| Değişimler | yüzde cinsinden liste (`10.0` = %10), oran değil |
| Bileşen ağırlıkları | pozitif; toplam 1 veya 100 olması gerekmez (formül normalize eder) ama **toplam rapora yazılır** |
| Karşılaştırma | önceki dönem (aylık), aynı dönem önceki yıl (yıllık); belirtilmemişse ikisini ver |
| Mevsimsel düzeltme | yapılmaz; kurumun onaylı aracına yönlendir |
| Yuvarlama | hesapta yok, yalnızca sunumda; `chain_index` 10 hane yuvarlar |

## Fonksiyonlar (`compute/src/tuik_calc/indices.py`)
| İmza | Davranış |
|---|---|
| `percent_change(current, previous) -> float` | `(current-previous)/previous*100`; `previous==0` → `ValueError` |
| `chain_index(base, changes_pct) -> list[float]` | `level *= 1 + c/100` ardışık; her adım listeye |
Bileşik endeks, taban değişimi ve Laspeyres için fonksiyon **yoktur** (aşağıdaki iskelet; eklersen `/new-calc` ile testli yaz).

## Formüller (standart tanım)
- Yüzde değişim: `(I_t − I_{t−1}) / I_{t−1} × 100`
- Zincirleme: `I_t = I_{t−1} × (1 + c_t/100)`
- Laspeyres fiyat endeksi: `I_t = Σ p_{i,t}·q_{i,0} / Σ p_{i,0}·q_{i,0} × 100`
- Ağırlıklı bileşik: `I = Σ(w_i · I_i) / Σ(w_i)`
- Taban değişimi: `I'_t = I_t / I_{yeni taban} × 100`
- Zincirleme birleştirme: yeni seri, örtüşme döneminde eski seriye çarpanla bağlanır: `k = I_eski(ö) / I_yeni(ö)`; `I_t(birleşik) = k × I_yeni(t)`.

## Adımlar
1. Dönemleri ve birimi doğrula (aynı periyot, aynı taban; eksik dönem yok).
2. `percent_change` ile dönemsel değişimi hesapla; `previous==0` hatasını yakala ve raporla.
3. Zincir gerekiyorsa `chain_index(base, changes)`.
4. Bileşik endekste ağırlık toplamını ve negatif/sıfır ağırlık olmadığını kontrol et.
5. Taban değişiminde birleşme noktasını **seri kırılması** olarak işaretle (`yayin-ve-revizyon`).
6. Mevsimsel/takvim düzeltmesi gerekiyorsa: elle yazma; kurumun onaylı aracı + parametre + sürümü kayda geç (araç adı burada **doğrulanmadı**).
7. Çapraz kontrol: elle hesap + ikinci yöntem (ör. zincirle sonra `percent_change` ile geri çöz).
8. Test: `pytest.approx`; sıfır payda, tek gözlem, boş liste.

## Şablon
```python
from tuik_calc.indices import percent_change, chain_index

def composite(indices: list[float], weights: list[float]) -> float:
    if len(indices) != len(weights) or not indices or any(w <= 0 for w in weights):
        raise ValueError("geçersiz girdi")
    return sum(w * i for w, i in zip(weights, indices)) / sum(weights)

def rebase(series: list[float], new_base_idx: int) -> list[float]:
    b = series[new_base_idx]
    if b == 0: raise ValueError("taban sıfır olamaz")
    return [v / b * 100.0 for v in series]

levels = chain_index(100.0, [1.0, -0.5, 2.0])
back = [percent_change(b, a) for a, b in zip([100.0] + levels[:-1], levels)]  # ikinci yöntem
```

## Örnek (sentetik)
`percent_change(110.0, 100.0)` → `10.0` · `chain_index(100.0, [10.0, -10.0])` → `[110.0, 99.0]` (ardışık +%10, −%10 geri 100 etmez) · `composite([102.0, 98.0], [3, 1])` → `101.0` · `percent_change(5, 0)` → `ValueError`.

## Bitti kontrol listesi
- [ ] Taban dönemi ve birim yazılı.
- [ ] Elle örnek + ikinci yöntemle çapraz kontrol.
- [ ] Ağırlık toplamı kontrol edildi ve raporlandı.
- [ ] Birleşme/taban değişimi seri kırılması olarak işaretli.
- [ ] Mevsimsel düzeltme varsa araç, sürüm, parametre kayıtlı.
- [ ] Docstring'de formül; formül/metodoloji değiştiyse `CHANGELOG.md` `compute:` notu (ship checklist).
- [ ] Sentetik veri; `pytest.approx`.

## Sık hatalar
- Yüzde (`10`) ile oranı (`0.10`) karıştırmak.
- Yüzde değişimleri toplayarak bileşik değişim hesaplamak (çarp!).
- Farklı tabanlı serileri doğrudan birleştirmek.
- Mevsimsel düzeltmeyi elle yazmak.
- Yıllık karşılaştırmada dönem hizasını bozmak.
- Eski sonuçları etkileyen değişikliği MAJOR saymamak (`04-ship-checklist.md`).

## İlgili
`compute/src/tuik_calc/indices.py` · `compute/tests/test_indices.py` · `.claude/rules/09-kalite-ve-dogrulama.md`, `04-ship-checklist.md` · skill: `py-hesaplama-modulu`, `kalite-raporu`, `yayin-ve-revizyon`.
