---
name: siniflandirma-esleme
description: Ekonomik faaliyet (NACE), meslek (ISCO), tüketim (COICOP) gibi sınıflamalar arasında sürümlü eşleme (crosswalk) ve kod doğrulama yapar. Kodlama ve sınıflama işlerinde kullan.
---
# Sınıflama ve eşleme (GSBPM 2/5)

Kural: sürümsüz kod kabul edilmez; referans tablo resmî kaynaktan alınır, modelin hafızasından yazılmaz.

## Ne zaman
Kodlama, sınıflama sürümü geçişi, iki sınıflama arası eşleme, kod doğrulama, etiket/arama.

## Girdiler ve varsayılanlar
| Girdi | Eksikse |
|---|---|
| Sınıflama + sürüm | sürüm eksikse **sor veya "sürüm bekleniyor" yaz**; tahmin etme |
| Referans tablo | `packages/contracts/classifications/` (**şu an repoda yok**: dizin ilk ihtiyaçta oluşturulur; içerik resmî kaynaktan, doğrulanmadan uydurulmaz) |
| Alanlar | `siniflandirma`, `surum`, `kod`, `ad_tr`, `ad_en`, `ust_kod`, `gecerli_baslangic`, `gecerli_bitis` |
| Belirsiz eşleme | otomatik seçme; `inceleme` kuyruğuna al |
| Test verisi | yapay/sentetik kodlar, gerçek tablodan alıntı yok |

## Adımlar
1. Kaynak ve hedef sürümü yaz (`NACE Rev.2` → `NACE Rev.2.1` gibi; hangi sürümlerin geçerli olduğu **resmî kaynaktan doğrulanır**).
2. Referans tabloları sürümlü dosya olarak yükle; biçimini doğrula (hane sayısı, desen).
3. Kod doğrulama: (a) biçim, (b) tabloda var mı, (c) üst seviye var mı, (d) geçerlilik dönemi.
4. Crosswalk'ı satır olarak tut: `kaynak_kod, kaynak_surum, hedef_kod, hedef_surum, iliski`; `iliski ∈ {1:1, 1:N, N:1, N:N}`.
5. `1:1` otomatik; `1:N` ve `N:N` için ek bilgi (ağırlık/ikincil değişken) gerekir, yoksa `inceleme`.
6. Sınıflama değişikliğini seri kırılması olarak işaretle (`yayin-ve-revizyon`).
7. Eşleme oranlarını kalite raporuna yaz (otomatik / incelenen / eşlenemeyen).
8. Etiket aramasında Türkçe karakter duyarsız eşleştirme (`turkce-arama` skill'i).

## Şablon
```python
import re
from dataclasses import dataclass

@dataclass(frozen=True)
class CodeRef:
    scheme: str      # "NACE"
    version: str     # "Rev.2"
    code: str

def validate_code(ref: CodeRef, table: dict[str, dict], pattern: str) -> list[str]:
    """table: kod -> {"ust_kod": ..., "gecerli": (baslangic, bitis)}; pattern resmî biçimden."""
    errs = []
    if not ref.version: errs.append("sürüm eksik")
    if not re.fullmatch(pattern, ref.code): errs.append("biçim hatalı")
    elif ref.code not in table: errs.append("tabloda yok")
    return errs

def classify_relation(rows: list[dict]) -> str:
    """rows: bir kaynak kodun crosswalk satırları."""
    return "1:1" if len(rows) == 1 else "1:N"
```
(İskelet örnektir; `compute/src/tuik_calc/` altında karşılığı yok. Eklersen `py-hesaplama-modulu` ile testli yaz.)

## Örnek (yapay kodlar)
Girdi: `CodeRef("DEMO","v1","A12")`, `pattern=r"[A-Z]\d{2}"`, `table={"A12": {...}}` → `[]`.
`CodeRef("DEMO","","A12")` → `["sürüm eksik"]`. `CodeRef("DEMO","v1","Z99")` → `["tabloda yok"]`.
Crosswalk: `A12(v1)→B01(v2)` tek satır = `1:1` (otomatik); `A13(v1)→B02,B03(v2)` = `1:N` → `inceleme`.

## Bitti kontrol listesi
- [ ] Her kodun yanında sürüm var.
- [ ] Referans tablo resmî kaynaktan; kaynak ve tarih notlandı.
- [ ] `1:N`/`N:N` eşlemeler insan incelemesinde; otomatik karar yok.
- [ ] Kod doğrulama: biçim, hiyerarşi, geçerlilik dönemi.
- [ ] Seri kırılması ve eşleme oranları raporlandı.
- [ ] Test: başarılı + hata yolu.

## Sık hatalar
- Kod listesini modelin hafızasından yazmak (halüsinasyon).
- Sürümsüz kod saklamak.
- Çoktan-bire eşlemeyi sessizce tek koda indirmek.
- Üst seviye kodu kontrol etmemek.
- Türkçe `İ/ı` yüzünden etiket aramasının kaçması.

## İlgili
`.claude/rules/11-metaveri-ve-siniflandirma.md` · `packages/contracts/README.md` · skill: `istatistik-gostergesi`, `turkce-arama`, `yayin-ve-revizyon`, `veri-temizleme`.
