# Örnek 5: Prompt serisiyle uygulama inşa etme
Hedef: "Gösterge Arama" — TÜİK göstergelerini hızlı arayan küçük bir web uygulaması (sentetik veri).

**Prompt 1 (kurulum + veri):**
> Bu dizinde Next.js (TS, App Router) iskeleti hazır. `src/lib/data` altında `SeriDataSource` adaptörünü kullan; `scripts/generate-sample-data.mjs` ile 200 sentetik gösterge üret (seed'li). Kabul: `npm test` yeşil.

**Prompt 2 (arama):** `turkce-arama` skill'iyle `foldTr` tabanlı arama kutusu; sonuç sayısı ve süre başlığı. Kabul: "ığdır/Çankırı" aksansız sorguyla bulunur.

**Prompt 3 (detay):** gösterge sayfası; birim, periyot, kaynak, `geçici/kesin` etiketi, `gizli` hücre gösterimi.

**Prompt 4 (tasarım):** `tasarim-dokumani` ile `DESIGN.md` yaz, ekranları ona uydur.

**Prompt 5 (kalite):** erişilebilirlik kontrolü, boş/hata durumları, testler.

**Prompt 6 (doküman):** README, "örnek veri" uyarısı, `/ship`.

Her adımdan sonra çalıştır, test et, commit'le. Hassas veri yok; yalnızca sentetik.
