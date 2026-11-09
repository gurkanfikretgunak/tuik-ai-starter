---
name: ifsa-kontrolu
description: Yayımlanacak tablolarda istatistiki ifşa kontrolü (küçük hücre, baskınlık, ikincil bastırma) için kontrol ve bastırma yapar. Tablo/API/grafik yayımlamadan önce her zaman kullan.
---
# İstatistiki ifşa kontrolü (GSBPM 7)
Amaç: tek bir birimin (kişi/işletme) değeri tablodan çıkarılamasın.
1. **Küçük hücre:** birim sayısı `min_count` altındaysa hücre bastırılır. `min_count` kurum kararıdır; kodda sabit değil, parametredir (`compute/src/tuik_calc/disclosure.py`).
2. **Baskınlık:** tek/az sayıda birim hücre toplamının büyük kısmını oluşturuyorsa (eşikler parametre) bastırma adayıdır.
3. **İkincil bastırma:** toplamlardan bastırılmış hücre geri hesaplanabiliyorsa ek hücre bastırılır.
4. Bastırılan hücre `"gizli"` kodu ile işaretlenir, `0` veya boş bırakılmaz.
5. Kırılım derinleştikçe (il × sektör × büyüklük) risk artar; çapraz tablo ve API filtrelerinde de uygula.
6. Sonucu `kalite-raporu` içine yaz: kaç hücre bastırıldı, hangi kural.
Uyarı: Bu skill genel yöntemi uygular; yasal çerçeve ve eşikler için kurumun ilgili birimi son sözü söyler (bkz. `01-veri-gizliligi.md`).
