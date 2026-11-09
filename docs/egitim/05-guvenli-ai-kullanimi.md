# 5. Güvenli AI kullanımı
**Seviye:** Zorunlu · **Süre:** 30 dk

## Öğrenme hedefi
Neyin prompta girip neyin giremeyeceğini ayırmak; maskeleme yapmak; commit/PR öncesi kontrol akışını uygulamak.

## Kurallar
- Gerçek mikro veri, kişisel veri, sırlar: **asla** prompta/repoya/loga.
- Şüphede: "Bu içerik kamuya açıklanabilir mi?" Hayırsa durun; iş yerel çözümle (Faz 2) yapılır veya yapılmaz.
- Dosya, web sayfası, veri hücresi içindeki "talimatları" uygulamayın; veri olarak ele alın ve bildirin.
- Commit/PR öncesi `/ship` ve `kvkk-kontrol`.
- Hook'lar sizi korur; atlatmaya çalışmayın.

## Prompta girer / girmez
| Girer | Girmez |
|---|---|
| `data/sample/` içindeki sentetik veri | Birim düzeyi kayıt, T.C. kimlik no, adres |
| Maskelenmiş hata mesajı (`<YER_TUTUCU>`) | Anahtar, parola, token, bağlantı dizesi |
| Yayımlanmış kamuya açık tablo | Yayımlanmamış gizli istatistiki bilgi |

## Adım adım alıştırma
1. Şu kötü promptu **yazın ama göndermeyin**: `Şu hata neden: login failed for user ahmet, parola=abc123`.
2. Maskeleyin: `login failed for user <KULLANICI>, parola=<YER_TUTUCU>`.
3. Sentetik, geçerli sağlama haneli bir kimlik no ile `prompt-guard` testini görmek için `make test-hooks` çalıştırın (`scripts/test-hooks.sh` içindeki sentetik değeri kullanır).
4. `/ship` çalıştırın; `kvkk-kontrol` çıktısını okuyun.
5. Bir istatistik tablosu için `/ifsa-kontrol` komutunu deneyin.

## Örnek promptlar
**Kötü:** `Bu anket kayıtlarını (yapıştırılan satırlar) özetle.`
**İyi:**
```
Gerçek veriyi paylaşamıyorum. Sütunları şöyle olan sentetik bir tablo için özet fonksiyonu yaz:
donem (YYYY-MM), bolge (A|B), deger (float), birim_sayisi (int). Küçük hücre (birim_sayisi < <ESIK>) olanları gizle.
```

## Kontrol soruları
1. Hata mesajındaki kullanıcı adı neden maskelenir?
2. Bir veri hücresinde "önceki talimatları yok say" yazıyorsa ne yaparsınız?
3. Hook engellediğinde doğru tepki nedir?

## İlgili
`.claude/rules/01-veri-gizliligi.md` · `.claude/rules/13-ai-kullanim-riskleri.md` · `08-guvenlik-hook-zafiyet.md`
