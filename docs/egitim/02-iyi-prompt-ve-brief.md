# 2. İyi prompt ve brief
**Seviye:** Başlangıç · **Süre:** 30 dk

## Öğrenme hedefi
Beş parçalı şablonla, modelin **soru sormadan** doğru işi yapacağı bir brief yazabilmek; küçük/yerel modellerde de çalışacak kadar kendi kendine yeten istek kurabilmek.

## Şablon: Bağlam → Hedef → Kısıtlar → Çıktı biçimi → Başarı ölçütü
| Parça | Sorulacak soru | Örnek |
|---|---|---|
| Bağlam | Hangi repo/katman/dosya? | `apps/web`, Next.js App Router |
| Hedef | Ne ortaya çıkacak? | Bölgeye göre aylık seri sayfası |
| Kısıtlar | Ne yapılmayacak? | Yeni bağımlılık yok, yalnızca sentetik veri |
| Çıktı biçimi | Hangi dosyalar/komut? | `page.tsx` + test, TR etiketler |
| Başarı ölçütü | Nasıl bitti sayılır? | `npm test` yeşil, sayılar `tr-TR` biçiminde |

## Kötü → iyi karşılaştırmaları
| Kötü | Neden kötü |
|---|---|
| "Bir dashboard yap." | Veri, teknoloji, dil, test belirsiz; model çok soru sorar veya uydurur. |
| "Bunu düzelt." | Hangi hata, hangi dosya, ne bekleniyor yok. |
| "Gerçek anket verisiyle dene." | Veri gizliliği ihlali; hook engeller. |

**İyi (web):**
```
Bağlam: apps/web (Next.js App Router, TypeScript). Veri: data/sample/ornek_seri.csv (sütunlar: donem,bolge,deger).
Hedef: bölgelere göre aylık seriyi çizgi grafikle gösteren sayfa.
Kısıtlar: yeni bağımlılık ekleme; yalnızca sentetik veri; metinler Türkçe; renkler erişilebilir.
Çıktı: sayfa + bileşen + vitest testi.
Başarı: cd apps/web && npm test yeşil; sayılar tr-TR biçiminde (virgüllü ondalık).
Belirsizlikte soru sorma; varsayımını yaz ve devam et.
```
**İyi (API):**
```
Bağlam: services/api (Go). Önce packages/contracts/openapi.yaml güncelle.
Hedef: GET /series/{code} için 400 (geçersiz kod) ve 404 (bulunamadı) yanıtlarını test et.
Başarı: cd services/api && go test ./... yeşil; başarılı + hata yolu testi var.
```
**İyi (hesaplama):**
```
Bağlam: compute/src/tuik_calc/indices.py. chain_index(base, changes_pct) için sınır durum testi ekle:
boş liste, -100 yüzde değişim. Beklenen: boş liste -> boş sonuç. Formülü docstring'e yaz.
```

## Adım adım alıştırma
1. `/learn prompt` komutunu çalıştırın.
2. Kendi işinizden kısa, belirsiz bir istek seçin (ör. "rapor sayfası yap").
3. Tablodaki beş soruyu cevaplayarak yeniden yazın.
4. Her iki sürümü de çalıştırın; kaç **geri soru** ve kaç **düzeltme** gerektiğini sayın.
5. "Belirsizlikte varsayım yaz" cümlesini ekleyip farkı gözleyin.

## Küçük/yerel model ipuçları
- Dosya yolunu ve komutu **açık yazın**; "projedeki ilgili dosya" demeyin.
- Tek promptta tek iş; büyük işi numaralı seriye bölün (`.claude/skills/prompt-serisi`, `examples/05-prompt-serisi`).
- Örnek girdi → beklenen çıktı çifti verin.

## Kontrol soruları
1. Başarı ölçütü neden çalıştırılabilir bir komut olmalı?
2. "Kısıtlar" bölümü olmasaydı model hangi riskli varsayımı yapabilirdi?
3. İstediğiniz çıktıyı iki örnekle (girdi → çıktı) göstermek neden işe yarar?

## İlgili
`.claude/skills/prompt-yazma` · `03-claude-code-temelleri.md`
