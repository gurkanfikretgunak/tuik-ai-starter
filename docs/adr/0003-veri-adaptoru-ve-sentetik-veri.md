# ADR 0003: Veri adaptörü ve sentetik veri
**Durum:** Kabul · **Tarih:** 2026-11-09

## Bağlam
Projeler örnek veriyle başlar, sonra gerçek kaynağa geçer; repoya gerçek veri girmemeli. Arayüz bileşenleri veri kaynağına bağlanırsa geçiş pahalı olur.

## Karar
- Veri erişimi `SeriDataSource` arayüzü arkasındadır (`apps/web/src/lib/data/types.ts`).
- Aktif kaynak **tek noktadan** seçilir: `getDataSource()` (`apps/web/src/lib/data/index.ts`); `DATA_SOURCE` ortam değişkeni, varsayılan `sample`. Tanımsız kaynak hata verir.
- Örnek veri seed'li üreticiyle sentetik üretilir (`scripts/generate-sample-data.mjs`, çıktı `data/sample/sentetik-seri.json`, `seed: 42`) ve arayüzde "örnek veri" olarak etiketlenir.

## Alternatifler
- Bileşenlerin doğrudan dosya/API okuması: geçiş zor, testler kırılgan.
- Rastgele (seed'siz) üretim: testler deterministik olmaz.

## Sonuçlar
- Gerçek kaynağa geçiş bileşenleri değiştirmez; yalnız yeni bir `SeriDataSource` uygulaması bağlanır.
- Testler deterministiktir; veri gizliliği riski azalır.
- Gerçek kaynak eklenirse veri sınıflandırması ve ifşa kontrolü (`ifsa-kontrolu`) önce yapılmalıdır.
- Kaynak: Şirket Sicil örneği.

## İlgili
`.claude/skills/veri-adaptoru` · `data/sample/README.md`
