---
name: veri-temizleme
description: Ham veriyi adlandırılmış doğrulama kuralları (validation.py), aykırı değer işaretleme, eksik değer kodlama ve izlenebilir düzeltme/doldurma akışıyla işler. Veri işleme/temizleme (GSBPM 5) aşamasında kullan.
---
# Veri temizleme (GSBPM 5)

Önce kurallar: ham veri **değişmez**; kontrol yalnızca bulgu (`Finding`) üretir; düzeltme ayrı, izli adımdır.

## Ne zaman
Ham veri geldikten sonra, ağırlıklandırma/endeks öncesi; her yeni veri sürümünde.

## Girdiler ve varsayılanlar
| Girdi | Eksikse varsayım |
|---|---|
| Veri | satır listesi `list[dict]` (sentetik; örn. `data/sample/sentetik-seri.json` içindeki `gozlemler`) |
| Aralık (`lo`,`hi`) | **parametre; kurum kararı** — verilmediyse yöntem belgesinden/yapılandırmadan iste, koda sabit yazma |
| Zorunlu alanlar | `donem`, `bolge`, `deger` |
| Tekil anahtar | `(donem, bolge)` birleşimi (tek alan yoksa birleşik anahtar alanı üret) |
| Toplam toleransı | `tol=1e-6` (yuvarlama varsa açıkça artır) |
| Aykırı değer | silme yok; `flag` |
| Eksik değer kodu | `yanıtsız`, `uygulanamaz`, `gizli`, `bilinmiyor`; asla `0` |

## Kurallar (`compute/src/tuik_calc/validation.py`)
| Kod | Fonksiyon | Anlamı |
|---|---|---|
| V001 | `check_range(rows, field, lo, hi)` | sayısal değer `[lo, hi]` dışında (eksik değer ayrı) |
| V002 | `check_required(rows, field)` | alan `None` veya `""` |
| V003 | `check_unique(rows, field)` | yinelenen değer (ilk görüldüğü satır mesajda) |
| V004 | `check_sum(rows, parts, total, tol=1e-6)` | Σparçalar ≠ toplam |
Hepsi `list[Finding]` döndürür; `Finding(rule, row, message)` değiştirilemez (frozen). `row` 0 tabanlı indekstir.

## Adımlar
1. Ham veriyi oku, **kopyala**; özgün nesneyi değiştirme.
2. Sırayla çalıştır: V002 → V003 → V001 → V004; bulguları tek listede topla.
3. Dönem sürekliliği ve birim değişimi için ayrı kontrol yaz (validation.py'de yok; gerekirse aynı `Finding` kalıbıyla `V005` ekle ve test et).
4. Aykırı değeri işaretle (`flag=True`, `neden`), düzeltmeyi kural veya insan kararıyla yap.
5. Her değişikliği günlüğe yaz: `satır, alan, önceki, sonraki, kural, tarih`.
6. Oranları hesapla: bulgu oranı, düzeltme oranı, doldurma oranı → `kalite-raporu`.
7. Çıktıyı **yeni dosya/sürüm** olarak yaz; test ekle (`compute/tests/test_validation.py` kalıbı).

## Şablon
```python
from tuik_calc.validation import check_range, check_required, check_unique, check_sum

rows = [dict(r) for r in raw_rows]               # kopya; ham veri değişmez
findings = (
    check_required(rows, "deger")
    + check_unique(rows, "key")                   # key = f"{donem}|{bolge}" üretilmiş alan
    + check_range(rows, "deger", lo=LO, hi=HI)    # LO/HI yapılandırmadan
    + check_sum(rows, ["a", "b"], "toplam")
)
audit = [{"row": f.row, "rule": f.rule, "message": f.message} for f in findings]
print(f"bulgu: {len(findings)}  oran: {len(findings)/max(len(rows),1):.1%}")
```

## Örnek (sentetik)
Girdi: `rows=[{"x":5},{"x":500},{"x":None}]`
`check_range(rows,"x",0,100)` → `[Finding(rule='V001', row=1, message='x=500 aralık dışı [0, 100]')]`
`check_required(rows,"x")` → `[Finding(rule='V002', row=2, message='x eksik')]`
`check_sum([{"a":1,"b":2,"t":4}],["a","b"],"t")` → `Finding V004 ... Σ['a', 'b']=3 ≠ t=4`

## Bitti kontrol listesi
- [ ] Ham veri dosyası değişmedi; çıktı yeni sürüm.
- [ ] Her kural adıyla (V001…) raporlandı; sessiz düzeltme yok.
- [ ] Eksikler kodlandı, `0` yok; doldurma yöntemi ve oranı yazıldı.
- [ ] `önceki → sonraki` günlüğü var.
- [ ] Yeni kural için başarılı + hata yolu testi (`pytest.approx` sayısalda).
- [ ] Yalnızca sentetik veri kullanıldı.

## Sık hatalar
- Aykırı değeri otomatik silmek veya eksiği 0 yapmak.
- Aralık sınırlarını koda gömmek (kurum parametresi).
- `check_range` eksik değeri yakalamaz sanmak; eksik için `check_required` çalıştır.
- Satır indeksini 1 tabanlı sanmak (0 tabanlı).
- `check_sum` için tolerans vermeyip yuvarlama farkına takılmak.

## İlgili
`compute/src/tuik_calc/validation.py` · `compute/tests/test_validation.py` · `.claude/rules/08-istatistik-surec.md`, `09-kalite-ve-dogrulama.md` · skill: `kalite-raporu`, `agirliklandirma-ornekleme`.
