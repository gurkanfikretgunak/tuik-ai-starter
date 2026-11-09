---
name: veri-adaptoru
description: Uygulamayı veri kaynağından soyutlayan adaptör deseni ve deterministik sentetik veri üreticisi. Örnek veriyle başlayıp sonra gerçek kaynağa geçilecek her projede kullan.
---
# Veri adaptörü + sentetik veri
(Şirket Sicil örnek projesinden uyarlanmıştır.)
1. **Arayüz:** `apps/web/src/lib/data/types.ts` içinde `SeriDataSource` (`getAll`, `getByKod`). Bileşenler yalnızca bunu bilir.
2. **Örnek kaynak:** `sample-source.ts` — SENTETİK veri, açıkça etiketli.
3. **Tek seçim noktası:** `index.ts` → `getDataSource()`; kaynak `DATA_SOURCE` ortam değişkeniyle seçilir. Gerçek kaynağa geçiş = yeni bir uygulama bağlamak, bileşenleri değiştirmemek.
4. **Gizli hücre:** `deger: null` + `durum: "gizli"`; asla 0.
5. **Sentetik veri üretici:** `node scripts/generate-sample-data.mjs <seed>` — aynı seed aynı çıktıyı verir; gerçekçi dağılım/ölçek ver ama gerçek kayıttan türetme.
6. **Uyarı:** arayüzde örnek veri kullanıldığında "Örnek veri — gerçek istatistik değildir" notu görünür.
7. Test: adaptör sözleşmesi için `data.test.ts` örneğini kopyala.
