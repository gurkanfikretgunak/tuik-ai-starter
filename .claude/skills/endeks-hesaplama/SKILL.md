---
name: endeks-hesaplama
description: Fiyat/miktar endeksleri (zincirleme, Laspeyres, ağırlıklı bileşik) ve yüzde değişim hesaplar. Endeks ve değişim oranı hesaplarında kullan; mevsimsel düzeltme için doğrulanmış araç yönlendirir.
---
# Endeks hesaplama (GSBPM 6)
- Yüzde değişim ve zincirleme endeks: `compute/src/tuik_calc/indices.py`.
- Bileşik endeks: `I = Σ(w_i · I_i) / Σ(w_i)`; ağırlıkların toplamı kontrol edilir.
- Taban değişimi (rebasing) ve zincirleme birleştirme (chain-linking) kurallarını yöntem belgesine yaz; birleşme noktasında seri kırılması raporlanır.
- Yıllık/aylık/çeyreklik karşılaştırmada **dönem uyumunu** doğrula.
- **Mevsimsel/takvim düzeltmesi:** elle yazma; kurumun onaylı aracını (ör. X-13/TRAMO-SEATS tabanlı) çağır, parametre ve sürümü kayda geç.
- Her hesabı elle hesaplanmış küçük bir örnekle ve ikinci bir yöntemle çapraz kontrol et.
