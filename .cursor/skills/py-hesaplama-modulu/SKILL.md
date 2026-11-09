---
name: py-hesaplama-modulu
description: Python'da istatistiksel/sayısal hesaplama modülü yazar (tip, test, doğrulama). Endeks, oran, ağırlıklandırma gibi hesaplamalarda kullan.
---
# Python hesaplama
1. İmza ve tipler: `def fonksiyon(x: pd.Series, ...) -> pd.Series`.
2. Docstring: formül, kaynak/metodoloji, birimler, örnek.
3. Sınır durumları: boş girdi, NaN, sıfıra bölme, negatif değerler — açık karar ve test.
4. Test: `compute/tests/`; bilinen elle hesaplanmış sonuçla karşılaştır.
5. Bağımsız doğrulama: sonucu ikinci bir yolla (ör. elle/başka formül) kontrol et.
6. Yalnızca sentetik veriyle çalış.
