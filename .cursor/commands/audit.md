Argüman almaz. Bağımlılık zafiyetlerini tarar ve `docs/security/zafiyet-kayitlari.md` kaydını günceller.

## Ne zaman
Bağımlılık eklendi/güncellendi, güvenlik uyarısı geldi veya haftalık gözden geçirme zamanı.

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| Kapsam | Tüm yığın (`scripts/vuln-track.py` ne tarıyorsa) |
| Sorumlu | Boşsa PR sahibi; hedef tarih: kritik 7 gün, yüksek 30 gün (parametre; kurum kararı) |
| Ağ erişimi yok | Dur, kullanıcıya bildir; sonuç uydurma |

## Kullanılan skill/kural
`zafiyet-takibi` skill'i; kural: `.claude/rules/14-zafiyet-takibi.md`.

## Adımlar
1. `make audit` çalıştır (`python3 scripts/vuln-track.py scan --write`; yeni bulguları kayda ekler).
2. `make audit-list` çalıştır (açık zafiyetler + hook bulguları).
3. Yeni kayıtları önem sırasıyla (Kritik > Yüksek > Orta > Düşük) özetle.
4. Her kayıtta sorumlu ve hedef tarih eksikse öner (`ZAF-YYYY-NNN`).
5. Süresi geçmiş kritik/yüksek kayıt varsa uyar: düzeltme veya gerekçeli "Kabul edildi (risk)".
6. Düzeltilebilenler için PR planı çıkar (hangi paket, hangi sürüm, hangi test).

## Çıktı biçimi
```
Yeni: N | Açık: M | Süresi geçmiş: K
| ID | Bileşen | Önem | Durum | Sorumlu | Hedef |
Önerilen düzeltme PR'ları: 1) ... 2) ...
```

## Örnek
`/audit` → 2 yeni bulgu (1 yüksek); ZAF kaydı eklendi, sorumlusu atanmadı → öneri sunulur.

## Bitti kontrol listesi
- [ ] `make audit` ve `make audit-list` çalıştı.
- [ ] Her kayıtta sorumlu + hedef tarih var.
- [ ] Düzeltme PR'ı kayıt ID'sini içerecek şekilde planlandı.

## Sık hatalar
- Tarama çalışmadan "temiz" demek.
- Düzeltmeden sonra durumu `Düzeltildi` yapıp test eklememek.
