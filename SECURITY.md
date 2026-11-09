# Güvenlik

## Bildirim
- Zafiyet veya hassas veri sızıntısı şüphesi: kurumun bilgi güvenliği birimine ve repo sorumlusuna **özel** kanaldan bildirin; herkese açık issue açmayın.
- Bildirimde ne/ne zaman/hangi bileşen yazın; hassas içeriği tekrar etmeyin (maskeleyin).
- Kurumun resmî olay yönetimi prosedürü varsa o önceliklidir. (İletişim adresini kurum belirleyip buraya ekleyin.)

## Bildirim şablonu
```
Ne: <kısa açıklama>
Ne zaman: <tarih/saat>
Bileşen: <dosya/komut/servis>
Etki: <veri sızıntısı | yetki | hizmet aksaması>
Kanıt: <maskelenmiş çıktı; gerçek veri YOK>
```

## Şüpheli sızıntıda ilk adımlar
1. Durun; içeriği tekrar etmeyin veya başka yere kopyalamayın.
2. Sır ise (anahtar, token, parola) hemen iptal/yenile; repo dışı gizli yönetiminden.
3. Bilgi güvenliği birimine bildirin; commit edildiyse geçmişi kendiniz yeniden yazmayın (force push yok), talimat bekleyin.

## Takip
- Zafiyet kayıtları: `docs/security/zafiyet-kayitlari.md` (sahip + hedef tarih zorunlu; `.claude/rules/14-zafiyet-takibi.md`)
- Taramalar: `make audit`, `make audit-list`
- Yapay zekâ riskleri: `docs/security/ai-kullanim-riskleri.md`
- Savunma hattı: `.claude/hooks/README.md` (hook'lar ilk hattır, tek başına yeterli değildir)
