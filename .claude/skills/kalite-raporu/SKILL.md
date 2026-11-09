---
name: kalite-raporu
description: İstatistik çıktısı için kalite raporu ve metaveri üretir (alaka, doğruluk, güncellik, dakiklik, erişilebilirlik, karşılaştırılabilirlik, tutarlılık, gizlilik). Değerlendirme (GSBPM 8) ve yayım öncesi kullan.
---
# Kalite raporu (GSBPM 8)

Boyutlar (Avrupa İstatistik Sistemi): **Alaka · Doğruluk ve güvenilirlik · Güncellik · Dakiklik · Erişilebilirlik · Karşılaştırılabilirlik · Tutarlılık** (+ bu repoda **Gizlilik**). Rakamlar betikten gelir; elle yazılmaz.

## Ne zaman
Yayım öncesi (sıra: doğrulama → ifşa → **kalite raporu** → yayım bayrağı) ve yayım sonrası değerlendirmede. `/kalite-kontrol` komutu da bunu çağırır.

## Girdiler ve varsayılanlar
| Girdi | Eksikse |
|---|---|
| Gösterge adı, dönem | PR/dosya adından al; yoksa `<GÖSTERGE>`, `<DÖNEM>` |
| Yanıt oranı | `yanıt veren / örneklem birimi`; veri yoksa "hesaplanamadı (veri yok)" |
| CV özeti | `weights.coefficient_of_variation` çıktılarından min/medyan/maks |
| Düzeltme/doldurma oranı | `veri-temizleme` günlüğünden |
| Güncellik | referans dönem sonu → yayım tarihi, gün |
| Dakiklik | planlanan vs gerçek yayım tarihi |
| Bastırma oranı | `disclosure` çıktısından `gizli hücre / toplam hücre` |
| Eşikler (CV, gecikme) | **parametre; kurum kararı**; rapora uygun/uygunsuz yargısı koyma, değeri yaz |
Ölçülemeyen satır boş bırakılmaz: `ölçülmedi — neden` yaz.

## Ölçüt tanımları
- Yanıt oranı = yanıtlayan / uygun birim × 100
- Düzeltme oranı = düzeltilen kayıt / toplam kayıt × 100 (doldurma ayrı satır)
- Güncellik = yayım tarihi − referans dönem sonu (gün)
- Revizyon büyüklüğü = |kesin − ilk yayım| / |ilk yayım| × 100 (`indices.percent_change` ile)
- Bastırma oranı = `gizli` hücre / tüm hücre × 100

## Adımlar
1. Şablonu aç: `.claude/skills/kalite-raporu/sablon.md`.
2. Başlığı doldur (gösterge, dönem).
3. Her ölçütü ilgili betik/çıktıdan hesapla (aşağıdaki iskelet); elle yazma.
4. Her boyut için en az bir ölçüt; yoksa `ölçülmedi — neden`.
5. Yöntem notu (ağırlık, doldurma, sınıflama sürümü), revizyon politikası, bilinen sınırlılıkları yaz.
6. Seri kırılması varsa Karşılaştırılabilirlik satırında belirt (sınıflama/yöntem değişikliği).
7. Raporu sürümlü kaydet (örn. `docs/` altında `kalite-<gosterge>-<dönem>.md`); gerçek veri ekleme.

## Şablon (betik iskeleti)
```python
from tuik_calc.indices import percent_change
def pct(n, d): return n / d * 100 if d else None

metrics = {
  "yanit_orani": pct(n_resp, n_sample),
  "duzeltme_orani": pct(n_edited, n_rows),
  "bastirma_orani": pct(sum(v == "gizli" for r in table for v in r), n_cells),
  "revizyon_pct": percent_change(final_value, first_value),
}
```
Tablo şablonu: `sablon.md` dosyasının tamamını kopyala.

## Örnek (sentetik)
Girdi: örneklem 200, yanıt 170, düzeltilen 12/170, 40 hücreden 3 gizli, ilk yayım 100.0 → kesin 101.0.
Çıktı: yanıt oranı 85,0 % · düzeltme 7,1 % · bastırma 7,5 % · revizyon `percent_change(101.0, 100.0)` = 1,0 %.

## Bitti kontrol listesi
- [ ] 8 boyutun hepsinde değer veya `ölçülmedi — neden`.
- [ ] Rakamlar betikten; kaynak komut/dosya notlandı.
- [ ] Bastırılan hücre oranı ve kural yazıldı.
- [ ] Yöntem notu, revizyon, sınırlılık dolu.
- [ ] Seri kırılması durumu belirtildi.
- [ ] Gerçek/mikro veri yok.

## Sık hatalar
- Rakamı elle yazmak.
- Boş hücre bırakmak.
- Eşik uygunluğunu kurum kararı olmadan yargılamak.
- Bastırma oranını atlamak.
- Yanıt oranını 0–1 ile yüzde karışıklığıyla yazmak.

## İlgili
`.claude/skills/kalite-raporu/sablon.md` · `.claude/rules/09-kalite-ve-dogrulama.md` · skill: `veri-temizleme`, `agirliklandirma-ornekleme`, `ifsa-kontrolu`, `yayin-ve-revizyon` · `/kalite-kontrol`.
