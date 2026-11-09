# Örnek 1: İlk promptla sayfa

## Ne öğretir
Tek, iyi yazılmış promptla (bağlam, hedef, kısıt, başarı ölçütü) çalışan ve testli bir sayfa üretmek.

## Önkoşul
`cd apps/web && npm install`; veri: `data/sample/ornek_seri.csv` (sütunlar `donem,bolge,deger`, sentetik).

## Çalıştırma
Claude Code'da:
```
/new-page Bölgelere göre aylık seriyi çizgi grafikle gösteren sayfa. Veri: data/sample/ornek_seri.csv. Türkçe etiketler, erişilebilir renkler, test dahil.
```
Sonra:
```bash
cd apps/web && npm test
cd apps/web && npm run dev     # http://localhost:3000
```

## Beklenen çıktı
- `apps/web/src/app/` altında yeni sayfa + bileşen, yanında test.
- Bölge A ve B için iki çizgi; sayılar `tr-TR` biçiminde (`100,0`); tablo alternatifi.
- `npm test` yeşil.

## Kontrol
Sayfa açılıyor mu? `npm test` yeşil mi? Sayılar `tr-TR` biçiminde mi? Renk dışı ayırt edici var mı? `git diff` kapsam dışı dosya içeriyor mu?

## Dosya haritası
`data/sample/ornek_seri.csv` (girdi) · `apps/web/src/lib/format.ts` (biçim) · `apps/web/src/lib/data/` (adaptör). Eğitim: `docs/egitim/03-claude-code-temelleri.md`.
