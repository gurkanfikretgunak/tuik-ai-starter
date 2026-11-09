---
description: Tüm yığını (API + web + hesaplama testi) yerelde başlat
---
Argüman almaz. Yerel geliştirme için üç sürecin komutlarını verir ve ortamı doğrular.

## Ne zaman
Projeyi ilk kez çalıştırırken veya tüm yığını birlikte denerken.

## Önemli
`make dev` hiçbir şey başlatmaz; yalnızca komutları ekrana **yazdırır**. Süreçleri aşağıdaki komutlarla ayrı terminallerde başlat.

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| API portu | 8080 |
| Web portu | 3000 |
| API adresi (web) | `NEXT_PUBLIC_API_URL=http://localhost:8080` |

## Kullanılan skill/kural
Skill gerekmez. Kurallar: `.claude/rules/02-guvenlik.md` (sır yazma), `01-veri-gizliligi.md`. Ön kontrol: `make doctor`.

## Adımlar
1. `make doctor` çalıştır; eksik araçları (go, node, python) raporla.
2. Web için örnek ortam dosyasını (`apps/web/` altındaki örnek) kopyalayıp yerel ortam dosyasını oluştur; yalnızca `NEXT_PUBLIC_API_URL` ayarla. Sır yazma.
3. Terminal 1: `cd services/api && go run ./cmd/api` → `http://localhost:8080/health`
4. Terminal 2: `cd apps/web && npm install && npm run dev` → `http://localhost:3000`
5. Terminal 3: `cd compute && python -m pytest -q`
6. Sağlık ucuna istek at (`curl http://localhost:8080/health`); web sayfasını aç.

## Çıktı biçimi
Üç komut bloğu + her biri için "beklenen sonuç" satırı + sorun varsa teşhis.

## Örnek
`/dev-fullstack` → üç terminal komutu, doctor sonucu, "API sağlıklı, web açıldı" doğrulaması.

## Bitti kontrol listesi
- [ ] `/health` 200 döndü.
- [ ] Web açıldı, API adresi doğru.
- [ ] `pytest` geçti.
- [ ] Ortam dosyasına sır yazılmadı.

## Sık hatalar
- `make dev` ile sunucu başlayacağını sanmak.
- Port çakışması: 8080/3000 dolu ise süreci kapat veya portu değiştir.
- Web, API adresi olmadan açılır; ortam değişkenini kontrol et.
