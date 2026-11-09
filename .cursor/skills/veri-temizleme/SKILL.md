---
name: veri-temizleme
description: Ham veriyi doğrulama kuralları, aykırı değer tespiti, eksik değer ele alma ve düzeltme (editing/imputation) akışıyla işler. Veri işleme/temizleme aşamasında kullan.
---
# Veri temizleme (GSBPM 5)
1. **Ham veri dokunulmaz.** Çıktı yeni dosya/sürüm olarak yazılır; dönüşümler betikle, tekrar çalıştırılabilir.
2. **Doğrulama kuralları** `compute/src/tuik_calc/validation.py` içinde adlandırılmış kurallar olarak tutulur: aralık, tür, zorunlu alan, kimlik tekilliği, alanlar arası tutarlılık (ör. toplam = parçaların toplamı), dönem sürekliliği.
3. **Aykırı değer:** otomatik silme yok. İşaretle (`flag`), nedenini yaz, düzeltmeyi kural veya insan kararıyla yap.
4. **Eksik değer:** kodları ayır (`yanıtsız`, `uygulanamaz`, `gizli`, `bilinmiyor`); sessizce 0 yapma. Doldurma (imputation) yöntemi ve oranı raporlanır.
5. **İz bırak:** her değişiklik için `önceki → sonraki`, kural kodu, tarih. Düzeltme oranı kalite raporuna girer.
6. Yalnızca sentetik veriyle test et; gerçek veri bu repoda çalıştırılmaz.
