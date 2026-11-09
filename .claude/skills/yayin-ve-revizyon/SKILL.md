---
name: yayin-ve-revizyon
description: Yayın takvimi, embargo, durum bayrakları (geçici/kesin/revize/gizli/tahmini) ve revizyon/seri kırılması yönetimi. Veri yayımlamadan, API'den seri sunmadan veya revizyon yapmadan önce kullan.
---
# Yayım ve revizyon (GSBPM 7)

Sıra: **doğrulama → `ifsa-kontrolu` → `kalite-raporu` → yayım bayrağı.** Hiçbiri atlanmaz.

## Ne zaman
Yeni seri/tablo yayımlarken, API'de seri sunarken, değer revize ederken, yöntem/sınıflama değiştirirken.

## Girdiler ve varsayılanlar
| Girdi | Eksikse varsayım |
|---|---|
| Yayın zamanı | takvim/yapılandırma dosyasından; yoksa **yayımlama**, `<TAKVİM_BEKLENİYOR>` yaz |
| Durum | yeni değer `geçici`; revizyon sonrası `kesin` ya da `revize` |
| Zaman dilimi | açık yaz (örn. `Europe/Istanbul`) |
| Dönem biçimi | ISO 8601: `2026-03`, `2026-Q1` |
| Revizyon politikası | göstergenin metaverisinden; yoksa "tanımsız" diye uyar |
| Önceki değer | her zaman saklanır |

## Durum değerleri (sözleşme: `packages/contracts/openapi.yaml`, `Observation.status`)
| Değer | Anlamı |
|---|---|
| `geçici` | ilk yayım, revize edilebilir |
| `kesin` | revizyon süreci tamam |
| `revize` | önceki yayımdan değişti |
| `gizli` | ifşa nedeniyle bastırıldı; `value` = `null` |
| `tahmini` | model/tahmin değeri |
Not: `disclosure.py` içinde bastırma kodu `"gizli"` dizgesidir; API'de `value: null` + `status: gizli` olarak dışa verilir (dönüşüm sunucuda).

## Adımlar
1. Yayın tarihini takvimden oku; `now < yayın_zamanı` ise veriyi API, statik dosya, önbellek, log ve önizlemeye **yazma** (embargo).
2. Yayın öncesi sırayla: doğrulama (`veri-temizleme`) → ifşa → kalite raporu.
3. Her gözleme `durum` ata; değer yoksa neden kodu (gizli/yanıtsız) ayrı.
4. Revizyonda: önceki değeri, yeni değeri, tarihi, **nedeni** kaydet; durumu `revize` yap.
5. Büyüklük: `percent_change(yeni, onceki)` ile revizyon yüzdesi; büyükse kalite raporuna yaz.
6. Yöntem/sınıflama değişikliği: seri kırılması işareti + metaveri notu + CHANGELOG.
7. Sözleşme alanı eksikse önce `openapi.yaml` güncelle (sözleşme önce); web/Go tüketicileri eşitle.
8. Yayım bayrağını son adım olarak aç; bayrak, zaman damgası ve kim onayladı yaz.

## Şablon
```python
from datetime import datetime, timezone
from tuik_calc.indices import percent_change

def can_publish(release_at: datetime, now: datetime, checks_ok: bool) -> bool:
    return checks_ok and now.astimezone(timezone.utc) >= release_at.astimezone(timezone.utc)

def revise(obs: dict, new_value: float, reason: str, when: str) -> dict:
    return {**obs, "onceki_deger": obs["deger"], "deger": new_value,
            "durum": "revize", "revizyon_nedeni": reason, "revizyon_tarihi": when,
            "revizyon_pct": percent_change(new_value, obs["deger"])}
```
(`can_publish` ve `revise` iskelettir; repoda karşılığı yok.)

## Örnek (sentetik)
Girdi: `{"donem":"2024-03","bolge":"A","deger":100.0,"durum":"geçici"}`, yeni değer `101.0`, neden "geç gelen yanıtlar".
Çıktı: `deger=101.0`, `onceki_deger=100.0`, `durum="revize"`, `revizyon_pct=1.0`. `release_at` gelecekteyse `can_publish(...)` → `False`.

## Bitti kontrol listesi
- [ ] Yayın zamanı takvimden; kodda sabit tarih yok.
- [ ] Embargo: yayın öncesi hiçbir açık yola veri düşmüyor.
- [ ] Her gözlemde `durum`; revizyonda önceki değer + neden.
- [ ] Seri kırılması işaretli, CHANGELOG notu eklendi.
- [ ] Doğrulama, ifşa, kalite raporu tamam; yayım bayrağı en sonda.
- [ ] Test: başarılı + hata yolu (erken yayım denemesi).

## Sık hatalar
- Önbellek/statik dosya yoluyla embargo ihlali.
- Revizyonda önceki değeri ezmek.
- `gizli` hücreyi 0 yayımlamak.
- Yöntem değişikliğini seri kırılması olarak işaretlememek.
- Saat dilimini belirtmemek.

## İlgili
`.claude/rules/12-yayin-ve-revizyon.md`, `10-ifsa-kontrolu.md` · `packages/contracts/openapi.yaml` · `data/sample/sentetik-seri.json` (`durum` alanı örneği) · skill: `ifsa-kontrolu`, `kalite-raporu`, `istatistik-gostergesi`, `endeks-hesaplama`.
