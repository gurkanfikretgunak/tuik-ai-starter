---
name: zafiyet-takibi
description: Bağımlılık ve kod zafiyetlerini tarar (make audit), docs/security/zafiyet-kayitlari.md kayıt defterine işler, önceliklendirir ve düzeltme akışını yönetir. Bağımlılık ekleme/güncelleme, güvenlik taraması veya zafiyet bildirimi sonrası kullan.
---
# Zafiyet takibi

## Ne zaman
- Bağımlılık eklendi/güncellendi (kural: `.claude/rules/14-zafiyet-takibi.md`).
- Tarama, hook uyarısı, kod incelemesi veya dış bildirim yeni bulgu getirdi.
- Yeni özellik PR'ı öncesi süresi geçen kritik/yüksek kayıt kontrolü.

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Tarama | `make audit` = `python3 scripts/vuln-track.py scan --write` |
| Listeleme | `make audit-list` = `list` + `hooks` |
| Araçlar | `npm audit --omit=dev` (`apps/web`, `package-lock.json` gerekir), `pip-audit` (`compute`), `govulncheck` (`services/api`); kurulu olmayan **atlanır**, hata vermez |
| Kayıt defteri | `docs/security/zafiyet-kayitlari.md` |
| ID | `ZAF-YYYY-NNN` (betik otomatik verir; `ORNEK-*` satırları sayılmaz) |
| Hedef süre | Kritik 7 gün · Yüksek 30 · Orta 90 · Düşük sonraki sürüm (örnek; kurum politikası geçerli) |
| Sorumlu | verilmezse `atanmadı` → **sahipsiz bırakma**, sorumluyu belirle |
| Durumlar | `Açık` · `İnceleniyor` · `Düzeltildi` · `Kabul edildi (risk)` · `Yanlış pozitif` |

Sorma; tara ve kaydet. Sorumlu kişiyi kullanıcı vermediyse "atanmadı" kaydet ve raporda uyar.

## Adımlar
1. **Tara:** `make audit`. "atlandı" mesajı çıkan aracı raporla (kurulum: `pip install pip-audit`; `go install golang.org/x/vuln/cmd/govulncheck@latest`). Ağ yoksa `npm audit` çalışmaz.
2. **Önceliklendir:** önem + erişilebilirlik (kod yolu gerçekten çağrılıyor mu?) + düzeltme var mı + yayında mı.
3. **Kaydet:** otomatik (`scan --write`) ya da elle:
   `python3 scripts/vuln-track.py add --kaynak "npm audit" --bilesen "next@15.0.0" --ozet "<özet>" --onem Yüksek --sorumlu web-ekibi --not "<not>"`
   Betik hedef tarihi önem düzeyinden hesaplar (Kritik +7, Yüksek +30, Orta +90, Düşük `-`).
4. **Düzelt:** en küçük güvenli güncelleme (ör. `cd apps/web && npm update <paket>`); yeni paket önerisinde paketin gerçekten var olduğunu ve bakım/lisans durumunu doğrula (slopsquatting riski).
5. **Doğrula:** `make test`, `make lint`, `make audit`; düzeltme için test ekle (hata düzeltmede önce hatayı üreten test).
6. **PR:** başlık/açıklamada `ZAF-YYYY-NNN`; commit örneği `fix(web): next güncellendi (ZAF-2026-001)`.
7. **Kapat:** kayıt satırında durumu `Düzeltildi` yap (dosyayı elle düzenle); risk kabulü ise gerekçe + onaylayan + tarih ekle.
8. **İzle:** `make audit-list` (haftalık hook bulguları); özet `python3 scripts/vuln-track.py summary` (oturum başında gösterilir).

## Şablon
Kayıt satırı (tablo sütunları: ID, Tarih, Kaynak, Bileşen, Özet, Önem, Durum, Sorumlu, Hedef tarih, Not):
```
| ZAF-2026-001 | 2026-11-09 | npm audit | example-lib@1.2.3 | <ÖZET> | Yüksek | Açık | web-ekibi | 2026-12-09 | <NOT> |
```
Risk kabulü notu: `Kabul edildi (risk): <gerekçe>; onay: <ROL>; gözden geçirme: <TARİH>`.

## Örnek
Girdi: `make audit` çıktısı `[Yüksek] npm audit · next@... · <başlık>` → `scan --write` satırı ekler. Beklenen rapor: "1 yeni kayıt ZAF-2026-00N, sorumlu atanmadı → web-ekibi atandı, hedef +30 gün; düzeltme: `npm update next`, testler geçti, kayıt `Düzeltildi`." Tarama araçları bulgusu kesin değildir; yanlış pozitifse durumu `Yanlış pozitif` yapıp nedenini yaz.

## Bitti kontrol listesi
- [ ] `make audit` çalıştı; atlanan araçlar raporlandı
- [ ] Her yeni bulgu kayıtta: kaynak, bileşen, önem, **sorumlu**, **hedef tarih**
- [ ] Süresi geçen kritik/yüksek kayıt ele alındı veya gerekçeli risk kabulü var
- [ ] Düzeltme PR'ı kayıt ID'sini içeriyor; test eklendi; durum `Düzeltildi`
- [ ] `make test` ve `make lint` temiz

## Sık hatalar
- Sahipsiz kayıt bırakmak; hedef tarih yazmamak.
- Aracın bulgusunu doğrulamadan "düzeltildi" demek (ya da AI önerisini test etmemek).
- Büyük sürüm atlayıp kırıcı değişiklik getirmek; en küçük güvenli güncellemeyi seç.
- `npm audit` için kilit dosyası olmadan taramak.
- `ORNEK-*` satırlarını silmek/gerçek sanmak.

## İlgili
`/audit` · `ai-risk-degerlendirme` · `kod-inceleme` · `.claude/rules/14-zafiyet-takibi.md` · `.claude/hooks/README.md` · `docs/security/zafiyet-kayitlari.md` · `scripts/vuln-track.py`
