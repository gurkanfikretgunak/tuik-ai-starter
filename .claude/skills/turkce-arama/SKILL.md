---
name: turkce-arama
description: Türkçe karakter duyarsız arama, süzme ve eşleşen kısmı vurgulama (İ/ı/I/i, Ş, Ğ, Ü, Ö, Ç). İl, faaliyet, gösterge adı gibi alanlarda arama yapılan her yerde kullan.
---
# Türkçe arama
- `apps/web/src/lib/tr-search.ts`: `foldTr`, `matchesTr`, `highlightTr`.
- `toLowerCase()` Türkçe için güvenilmezdir (`İ` → `i̇`). Katlama 1:1 karakter eşlemesiyle yapılır, uzunluk korunur → vurgulama indeksleri doğru kalır.
- Vurgu: `highlightTr` segment döndürür; arayüz `match` olan parçayı `<mark>` ile gösterir (dangerouslySetInnerHTML kullanma).
- Büyük listelerde sunucu tarafında indeksle (ör. MiniSearch); katlama aynı fonksiyonla yapılır.
- Test: `İSTANBUL/ığdır/Çankırı` örnekleri `tr-search.test.ts` içinde.
