---
name: prompt-yazma
description: İyi prompt ve iş brief'i yazmayı öğretir; kullanıcının isteğini daha net hale getirir (Bağlam → Hedef → Kısıtlar → Çıktı → Başarı ölçütü). Eğitim ve "AI'dan nasıl istemeliyim" sorularında, zayıf bir promptu iyileştirirken kullan.
---
# İyi prompt = iyi brief

## Ne zaman
Kullanıcı "nasıl isterim?", "promptumu düzelt" dediğinde; eğitimde; büyük bir iş başlatmadan önce brief hazırlarken. Büyük uygulamalar için `prompt-serisi`.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Kullanıcının promptu | alınır, olduğu gibi değerlendirilir |
| Eksik bağlam | repodan çıkar (stack, yol, komut); çıkarılamıyorsa "Varsayım:" yaz |
| Yığın | Next.js `apps/web`, Go `services/api`, Python `compute` |
| Veri | yalnızca sentetik (`data/sample/`) |
| Dil | arayüz/doküman Türkçe, kod İngilizce |
| Çıktı | geliştirilmiş prompt + eksik listesi (kısa) |

Sorma; eksikleri tahminle doldurup işaretle. Yalnızca hedef ya da veri hassasiyeti belirsizse tek soru sor.

## Şablon
**Bağlam → Hedef → Kısıtlar → Çıktı biçimi → Başarı ölçütü**
```
Bağlam: <proje/dizin, ilgili dosya, önceki adım>
Hedef: <tek cümle, ölçülebilir>
Kısıtlar: <yığın, sentetik veri, Türkçe arayüz, bağımlılık ekleme, dokunulmayacak dosyalar>
Çıktı biçimi: <hangi dosyalar, test dahil mi, rapor biçimi>
Başarı ölçütü: <komut → beklenen sonuç; ör. `make test` yeşil>
```

## Adımlar (promptu iyileştir)
1. Promptu oku; 5 parçadan hangileri eksik işaretle.
2. Belirsiz kelimeleri ("güzel", "hızlı", "bir şey") ölçülebilir ifadeyle değiştir.
3. Gerçek dosya/komutları ekle (`data/sample/ornek_seri.csv`, `make test`).
4. Büyük işi böl; önce **plan iste** ("önce plan, onaylarsam kod").
5. Örnek girdi/çıktı ekle (sentetik).
6. Hassas veri varsa çıkar ve uyar (gerçek veri/kimlik/sır yapıştırma).
7. Başarı ölçütünü komuta bağla.
8. Çıktıyı göster: "Eksikler" + "Geliştirilmiş prompt".

## Örnek
Zayıf: "Bir dashboard yap."

Eksikler: yığın, veri, grafik türü, dil, erişilebilirlik, test, başarı ölçütü.

Güçlü:
```
Bağlam: apps/web (Next.js App Router). Veri: data/sample/ornek_seri.csv (sentetik; sütunlar donem,bolge,deger).
Hedef: Bölgelere göre aylık seriyi gösteren /seri sayfası.
Kısıtlar: veri adaptörü (getDataSource) kullan; çizgi grafik; Türkçe etiketler, sayılar tr-TR; erişilebilir renkler + tablo alternatifi; yeni bağımlılık ekleme.
Çıktı: page.tsx, bileşen, Vitest testi; kısa özet.
Başarı: `cd apps/web && npm test` yeşil; gizli hücre 0 olarak gösterilmiyor.
```

İkinci örnek (hata düzeltme): "Çalışmıyor düzelt" → "`cd compute && python -m pytest` `test_weights.py::test_cv` hatasıyla düşüyor (hata metni: <YAPIŞTIR>). Önce hatayı yeniden üreten test yaz, sonra düzelt; yalnızca `weights.py`'a dokun."

## İpuçları
Örnek ver · büyük işi böl · önce plan iste · sonucu test ile doğrula · hassas veri yapıştırma · modele "bunu doğrulamadan doğru kabul etme" de · yerel/küçük model kullanıyorsan promptu kısa, adımlı ve dosya yollarıyla yaz.

## Bitti kontrol listesi
- [ ] 5 parça da var
- [ ] Başarı ölçütü komut/gözlem olarak yazılı
- [ ] Gerçek dosya/komut adları kullanıldı
- [ ] Hassas veri yok; sentetik örnek var
- [ ] Büyük işse plan veya bölme önerildi

## Sık hatalar
- Hedefi tek kelimeyle vermek ("dashboard").
- Kısıtları (yığın, veri, dil) yazmamak.
- Hepsini tek devasa promptta istemek.
- Gerçek veri/sır yapıştırmak (hook engeller; yine de yapma).
- Sonucu test etmeden kabul etmek.

## İlgili
`prompt-serisi` · `/learn` · `docs/egitim/02-iyi-prompt-ve-brief.md` · `examples/01-ilk-prompt-ile-sayfa/README.md` · `.claude/rules/01-veri-gizliligi.md`
