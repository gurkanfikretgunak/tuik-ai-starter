---
paths:
  - "compute/**"
  - "packages/contracts/**"
  - "data/**"
---
# İstatistik üretim süreci
GSBPM aşamalarına göre çalış (`gsbpm-surec-haritasi` skill'i). Genel ilkeler:
- **Ham veri değişmez.** İşlenmiş çıktı yeni dosya/sürüm olarak yazılır.
- **Tekrarlanabilirlik:** hesap betikle çalışır; rastgelelik varsa sabit `seed`; kullanılan veri sürümü, kod sürümü (git), parametreler ve tarih çıktıyla birlikte kaydedilir.
- **İzlenebilirlik:** her düzeltme/doldurma `önceki → sonraki` + kural kodu ile kaydedilir.
- **Eksik değer ≠ 0.** Kodları ayır: yanıtsız, uygulanamaz, gizli, bilinmiyor.
- **Birim ve periyot** her sayının yanında bilinir (TL/bin TL, yıllık/aylık, referans dönem).
- Notebook keşif içindir; üretim hesabı modül olarak `compute/src` içinde, testli yazılır.
- Kurumsal eşik, kural ve yöntemler koda gömülmez; yapılandırma + yöntem belgesinden gelir.
