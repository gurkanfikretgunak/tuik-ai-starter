# 1. AI nedir, ne değildir?
**Seviye:** Başlangıç · **Süre:** 20 dk

## Öğrenme hedefi
Bu bölümün sonunda: (1) AI asistanının güçlü ve zayıf yanlarını sayabilir, (2) bir çıktıyı bağımsız yöntemle doğrulayabilir, (3) hangi içeriğin prompta girip hangisinin giremeyeceğini ayırt edebilirsiniz.

## Temel fikirler
- AI asistanı hızlı bir **yardımcıdır**; karar vericinin yerini almaz. Sorumluluk sizdedir.
- Yanlış ama kendinden emin cevap verebilir ("halüsinasyon"): olmayan paket adı, uydurma formül, var olmayan dosya yolu.
- **Verdiğiniz bağlam kadar iyi çalışır.** Belirsiz istek, genel (ve çoğu zaman yanlış) varsayım üretir.
- Yapay zekâ çıktısı **kanıt değildir** (`CLAUDE.md` kural 4): bağımsız doğrulayın.
- Hassas veri paylaşılmaz (`.claude/rules/01-veri-gizliligi.md`). Şüphede soru: "Bu içerik kamuya açıklanabilir mi?" Hayırsa durun.

## İyi / kötü kullanım
| Uygun | Uygun değil |
|---|---|
| Sentetik veriyle fonksiyon ve test iskeleti | Gerçek mikro veriyi yapıştırıp "özetle" demek |
| Hata mesajını (gizli bilgi maskelenmiş) açıklatmak | Üretilen formülü kontrol etmeden yayımlamak |
| Dokümantasyon taslağı, kod inceleme ikinci gözü | "Bu tablo ifşa riski taşıyor mu?" sorusunu tek başına AI'ya bırakmak |

## Adım adım alıştırma (20 dk)
1. Kendi işinizden **küçük, sentetik** bir görev seçin (ör. "aylık değişimden yüzde değişim hesaplayan fonksiyon").
2. Aşağıdaki "kötü" promptu çalıştırın, çıktıyı not edin; sonra "iyi" promptla tekrarlayın.
3. Sonucu **elle** doğrulayın: `compute/src/tuik_calc/indices.py` içindeki `percent_change` ile karşılaştırın veya hesap makinesiyle iki örnek deneyin.
4. Bir tabloya şu üç satırı yazın: *AI'nın doğru yaptığı*, *yanlış/eksik yaptığı*, *benim düzelttiğim*.

## Örnek prompt'lar (kopyala-yapıştır)
**Kötü:** `Yüzde değişimi hesapla.`
**İyi:**
```
Python 3 için percent_change(current: float, previous: float) -> float yaz.
Formül: (current - previous) / previous * 100. previous == 0 ise ValueError fırlat.
Sentetik örnek: current=102.5, previous=100.0 -> 2.5.
pytest ile bir başarılı yol ve bir hata yolu testi ekle. Yeni bağımlılık ekleme.
```
**Doğrulama promptu:**
```
Yukarıdaki fonksiyonda hangi varsayımları yaptın? Doğrulayamadığın bir şey varsa "doğrulanmadı" diye işaretle.
```

## Kontrol soruları
1. AI "kesin" dediğinde neden yine de doğrulama yaparsınız?
2. Bir hata mesajında kişisel veri varsa prompta yapıştırmadan önce ne yaparsınız?
3. Bir paket önerildiğinde "gerçekten var mı?" sorusunu nasıl yanıtlarsınız?
4. Hangi tür içerik buluta gidemez ve alternatif nedir? (Cevap: `agents-local/README.md`, Faz 2.)

## İlgili
`02-iyi-prompt-ve-brief.md` · `05-guvenli-ai-kullanimi.md` · `docs/security/ai-kullanim-riskleri.md`
