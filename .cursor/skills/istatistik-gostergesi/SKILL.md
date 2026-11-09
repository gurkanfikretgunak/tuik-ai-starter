---
name: istatistik-gostergesi
description: İstatistik göstergesi/seri tanımı ve metaverisi hazırlar (kod, ad TR/EN, birim, periyot, kapsam, kaynak, yöntem, revizyon politikası, gizlilik sınıfı). Gösterge veya veri seti modellenirken kullan.
---
# Gösterge tanımı (GSBPM 2)

Her gösterge/seri metaveriyle gelir; çıktı `packages/contracts/` altında JSON Schema + örnek kayıt. Mümkünse SDMX kavramlarıyla (boyut, ölçü, öznitelik) uyumlu adlandır.

## Ne zaman
Yeni gösterge/seri/veri seti tanımlanırken, API sözleşmesine alan eklenirken, metaveri eksik olduğunda.

## Girdiler ve varsayılanlar
| Alan | Eksikse varsayım |
|---|---|
| `code` | büyük harf, `_` ayraçlı, ≤ 64 karakter (API `/series/{code}` `maxLength: 64`) |
| `name_tr` / `name_en` | TR zorunlu; EN proje istiyorsa |
| `unit` | açık yaz (`endeks (2015=100)`, `TL`, `bin kişi`); bilinmiyorsa `<BİRİM>` |
| `frequency` | `M` (aylık); `Q`, `A` seçenekleri |
| `period_format` | ISO 8601 (`2026-03`, `2026-Q1`) |
| `coverage` | `<KAPSAM>` |
| `source` | `sentetik` (örnek veride) |
| `methodology_note` | `<YÖNTEM>` |
| `revision_policy` | `geçici → kesin` varsayılan akış; ayrıntı `yayin-ve-revizyon` |
| `confidentiality_class` | `kamuya_acik` yalnızca ifşa kontrolünden geçmişse; aksi `kisitli` |
| `classification` | `{scheme, version}`; sürümsüz yazılmaz |

## Adımlar
1. Göstergeyi tek cümleyle tanımla; kodunu belirle.
2. Yukarıdaki alanları varsayılanlarla doldur; bilinmeyeni `<YER_TUTUCU>` bırak.
3. SDMX eşlemesi: boyutlar (`period`, `region`, sınıflama), ölçü (`value`), öznitelikler (`status`, `unit`).
4. Sözleşmeyi önce güncelle: `packages/contracts/openapi.yaml` (tek sözleşme dosyası; ikinci dosya açma). Mevcut `Series` ve `Observation` şemaları (`code,name,unit,observations`; `period,region,value,status`) ile uyumlu kal.
5. Metaveri şemasını `packages/contracts/` altında JSON Schema olarak ekle; örnek kayıtla doğrula.
6. API alanı değiştiyse `api-client-ts` ve CHANGELOG (`api:`) güncelle; geriye uyumsuzsa sürüm yükselt.
7. Örnek kayıt yalnızca sentetik değerlerle.

## Şablon
```json
{
  "code": "<GOSTERGE_KODU>",
  "name_tr": "<Türkçe ad>",
  "name_en": "<English name>",
  "unit": "<birim>",
  "frequency": "M",
  "period_format": "ISO8601",
  "coverage": "<kapsam>",
  "source": "sentetik",
  "methodology_note": "<yöntem notu>",
  "revision_policy": "geçici -> kesin; revizyonda önceki değer saklanır",
  "confidentiality_class": "kisitli",
  "classification": { "scheme": "<SINIFLAMA>", "version": "<SURUM>" },
  "dimensions": ["period", "region"],
  "measure": "value",
  "attributes": ["status", "unit"]
}
```

## Örnek (sentetik)
Girdi: "Bölgelere göre aylık örnek seri." → `code=ORNEK_SERI_M`, `unit="endeks"`, `frequency=M`, boyutlar `period`,`region`, `confidentiality_class=kisitli`; örnek gözlem `{"period":"2024-01","region":"A","value":100.3,"status":"kesin"}` (`data/sample/` biçimine uygun).

## Bitti kontrol listesi
- [ ] Tüm alanlar dolu veya açık yer tutucu.
- [ ] Birim, periyot, referans dönem açık; ISO 8601.
- [ ] Sınıflama sürümlü.
- [ ] `openapi.yaml` önce güncellendi; JSON Schema + örnek kayıt var.
- [ ] Örnek kayıt sentetik; geriye uyum notu/CHANGELOG.

## Sık hatalar
- Birimi veya taban yılını yazmamak.
- Sürümsüz sınıflama kodu.
- Yeni sözleşme dosyası açmak (tek dosya: `openapi.yaml`).
- Durum alanını eksik bırakmak.
- Gizlilik sınıfını ifşa kontrolü olmadan `kamuya_acik` yapmak.

## İlgili
`.claude/rules/11-metaveri-ve-siniflandirma.md` · `packages/contracts/openapi.yaml`, `README.md` · skill: `siniflandirma-esleme`, `yayin-ve-revizyon`, `api-client-ts`, `gsbpm-surec-haritasi`.
