---
name: siniflandirma-esleme
description: Ekonomik faaliyet (NACE), meslek (ISCO), tüketim (COICOP) gibi sınıflamalar arasında sürümlü eşleme ve kod doğrulama yapar. Kodlama ve sınıflama işlerinde kullan.
---
# Sınıflama ve eşleme
- Her kod **sürümü ile** saklanır (ör. `NACE Rev.2`, `kod`, `ad_tr`, `ad_en`). Sürümsüz kod yazma.
- Sürümler arası eşleme tablosu (crosswalk) **bire-çok / çoktan-bire** durumlarını açıkça gösterir; belirsiz eşlemeler insan incelemesine düşer.
- Kod doğrulama: biçim (uzunluk, hane), hiyerarşi (üst seviye var mı), geçerlilik dönemi.
- Referans tablolar `packages/contracts/classifications/` altında sürümlü dosyalar olarak tutulur; resmî kaynaktan alınır, elle uydurulmaz.
- Arama/etiket gösteriminde Türkçe karakter duyarsız eşleştirme kullan (`tr-search`).
