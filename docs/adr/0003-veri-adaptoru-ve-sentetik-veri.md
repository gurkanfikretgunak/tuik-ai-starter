# ADR 0003: Veri adaptörü ve sentetik veri
**Durum:** Kabul · **Tarih:** 2026-11-09
**Bağlam:** Projeler örnek veriyle başlar, sonra gerçek kaynağa geçer; repoya gerçek veri girmemeli.
**Karar:** Veri erişimi `SeriDataSource` arayüzü arkasındadır; aktif kaynak tek noktadan seçilir; örnek veri seed'li üreticiyle sentetik üretilir ve arayüzde etiketlenir.
**Sonuçlar:** Gerçek kaynağa geçiş bileşenleri değiştirmez; testler deterministiktir; veri gizliliği riski azalır. Kaynak: Şirket Sicil örneği.
