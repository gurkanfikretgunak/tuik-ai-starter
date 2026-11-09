# Zafiyet takibi
- Bağımlılık ekleyen/güncelleyen her PR `make audit` çalıştırır; yeni bulgular `docs/security/zafiyet-kayitlari.md` içine (`ZAF-YYYY-NNN`) işlenir.
- Her kayıtta: kaynak, bileşen, önem, durum, **sorumlu**, **hedef tarih**. Sahipsiz kayıt bırakılmaz.
- Süresi geçen kritik/yüksek kayıt varsa yeni özellik PR'ı açmadan önce ele alınır veya gerekçeli "Kabul edildi (risk)" onayı yazılır.
- Düzeltme PR'ı kayıt ID'sini içerir; düzeltmeden sonra durum `Düzeltildi` yapılır ve test eklenir.
- Hook bulguları (`make audit-list`) haftalık gözden geçirilir.

## Kayıt şablonu (`docs/security/zafiyet-kayitlari.md`)
```
### ZAF-2026-001
- Kaynak: <audit/hook/rapor>  - Bileşen: <paket@sürüm>  - Önem: <kritik|yüksek|orta|düşük>
- Durum: <Açık|Düzeltildi|Kabul edildi (risk)>  - Sorumlu: <AD>  - Hedef tarih: <YYYY-AA-GG>
```
## Karar tablosu
| Durum | Eylem |
|---|---|
| Bağımlılık eklendi/güncellendi | `make audit` |
| Yeni bulgu | Kayda ekle, sorumlu + tarih yaz |
| Süresi geçmiş kritik/yüksek | Önce çöz veya gerekçeli "Kabul edildi (risk)" |
| Düzeltme PR'ı | Başlıkta kayıt ID, durum `Düzeltildi`, test ekle |
| Haftalık | `make audit-list` gözden geçir |

## Do / Don't
- DON'T: sahipsiz/tarihsiz kayıt bırak. DON'T: zafiyeti sessizce yoksay. Skill: `zafiyet-takibi`, komut: `/audit`.
