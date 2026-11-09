Hesaplama: $ARGUMENTS

## Ne zaman
Yeni bir oran, endeks, ağırlıklandırma, CV gibi hesaplama gerektiğinde.

## Argüman sözdizimi ve varsayılanlar
`/new-calc <hesaplama tanımı>` — örn. `/new-calc ağırlıklı ortalama ve CV`.

| Eksik girdi | Varsayım |
|---|---|
| Yer | `compute/src/tuik_calc/<modul>.py`, test `compute/tests/test_<modul>.py` |
| Girdi tipi | Sayısal liste/dizi, tip ipuçlu saf fonksiyon |
| Sınır durumları | Boş girdi, sıfır ağırlık, negatif, NaN → açık hata |
| Eşik/parametre | Fonksiyon parametresi (kurum kararı; koda gömme) |
| Veri | Sentetik, testte elle yazılmış |

## Kullanılan skill/kural
`py-hesaplama-modulu` (ana); konuya göre `agirliklandirma-ornekleme`, `endeks-hesaplama`, `veri-temizleme`. Kurallar: `.claude/rules/hesaplama-python.md`, `09-kalite-ve-dogrulama.md`, `test.md`.

## Adımlar
1. `compute/src/tuik_calc` ve mevcut testlere bak; benzer modülü örnek al.
2. Formülü yaz (standart tanım) ve kaynağı docstring'e koy.
3. Önce hata yolu ve sınır testlerini yaz (başarısız görünsün).
4. Tip ipuçlu, girdi doğrulayan saf fonksiyonu yaz.
5. Elle hesaplanmış bir örnekle doğrula.
6. `cd compute && python -m pytest -q` çalıştır; `make lint`.
7. Metodoloji değiştiyse `CHANGELOG.md` içine `compute:` notu.

## Çıktı biçimi
Değişen dosyalar listesi, formül, test sonucu (geçen/kalan), açık varsayımlar.

## Örnek
`/new-calc yüzde değişim` → `change.py`: `pct_change(prev, curr)`; `prev == 0` için `ValueError`; testler: normal, sıfır, negatif.

## Bitti kontrol listesi
- [ ] Docstring'de formül ve kaynak var.
- [ ] Başarılı yol + hata yolu + sınır testleri geçiyor.
- [ ] Elle örnek doğrulandı.
- [ ] `make lint` ve `make test` temiz.
- [ ] Eski sonuçları etkiliyorsa MAJOR notu yazıldı.

## Sık hatalar
- Eşiği veya katsayıyı koda gömmek.
- Sıfıra bölmeyi yakalamamak.
- Gerçek veriyle test yazmak.
