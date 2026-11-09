---
name: proje-baslat
description: Fikirden çalışan iskelete kadar yeni proje başlatır (en çok 4 soru → PRD → şablon → sözleşme → plan → make test). Yeni proje, PRD, şablon seçimi veya "nereden başlayayım" istendiğinde kullan.
---
# Proje başlatma

## Ne zaman
Sıfırdan yeni proje/uygulama/hesaplama başlarken, "nereden başlayayım?" sorusunda, PRD veya şablon seçimi gerektiğinde. Komut: `/new-project <ad> [web|api|calc|fullstack]`.

## Girdiler ve varsayılanlar
Kullanıcı vermediyse **sorma**, aşağıdakini varsay ve PRD'de "Varsayım" olarak yaz:

| Girdi | Varsayılan |
|---|---|
| Proje adı | `kebab-case` (`<konu>-<tür>`), kullanıcı vermediyse konudan türet |
| Hedef yer | `projects/<ad>/` (şablon buraya kopyalanır) |
| Şablon | web arayüzü → `web-dashboard`; yalnızca API → `go-service`; yalnızca hesap → `py-calculation`; belirsiz/hepsi → `fullstack-minimal` |
| Veri | **sentetik** (`data/sample/`); gerçek veri yok |
| Kullanıcı | TÜİK personeli |
| Dil | arayüz/doküman Türkçe, kod İngilizce |
| Başarı ölçütü | `make test` yeşil + çalışan ilk ekran/uç |
| Sözleşme | veri alışverişi varsa `packages/contracts/openapi.yaml` taslağı |

Şablonlar `templates/` altında (her biri bir README; gerçek kopyalanacak parçalar):
- `web-dashboard`: `apps/web` + `veri-gorsellestirme` skill'i
- `go-service`: `services/api` + `packages/contracts`
- `py-calculation`: `compute`
- `fullstack-minimal`: `apps/web`, `services/api`, `compute`, `packages/contracts`

**Yalnızca şu durumda sor (en çok 4 soru, tek mesajda):** problem belirsizse; veri hassas olabilirse; hedef kullanıcı/başarı ölçütü hiç çıkarılamıyorsa.

## Adımlar
1. Hassas veri olasılığı varsa önce `.claude/rules/01-veri-gizliligi.md` (ve `ai-risk-degerlendirme`).
2. Soruları sor (yukarıdaki koşulda), aksi halde varsayımları yaz.
3. PRD: `.claude/skills/proje-baslat/templates/prd.md` şablonunu doldur; `projects/<ad>/prd.md` olarak kaydet (1 sayfa).
4. Şablonu seç ve `projects/<ad>/` altına kopyala (aşağıdaki komut).
5. Sözleşme taslağı: yeni uç/şema varsa `packages/contracts/openapi.yaml` içinde (ikinci sözleşme dosyası açma; `go-api-endpoint`).
6. Plan: `.claude/skills/proje-baslat/templates/plan.md` ile en çok 7 adım; **1. adım 1 saatte bitecek kadar küçük**; kullanıcı onayını al (kritik değilse bir satır özetle ilerle).
7. İlk adımı uygula (örnek veriyle, `veri-adaptoru`).
8. Doğrula: `make doctor`, `make test`, `make lint`.
9. Kullanıcıya rapor: yapılanlar, çalışan komutlar, varsayımlar, sonraki adım.

## Şablon
Kopyalama (fullstack örneği; dosya listesi `templates/*/README.md`'ye göre ayarla):
```bash
mkdir -p projects/<ad>
cp -R apps/web services/api compute projects/<ad>/
mkdir -p projects/<ad>/packages && cp -R packages/contracts projects/<ad>/packages/
```
Çalıştırma: web `cd apps/web && npm install && npm run dev`; API `cd services/api && go run ./cmd/api`; hesap `cd compute && python -m pytest`.
PRD ve plan şablonları: `templates/prd.md`, `templates/plan.md` (bu skill klasöründe).

## Örnek
Girdi: `/new-project fiyat-izleme web` → şablon `web-dashboard`; PRD: problem "aylık fiyat endeksini bölgelere göre görmek", veri sentetik, başarı "sayfa açılır, `npm test` yeşil"; plan 5 adım (1. adım: veri adaptörü + sentetik seri).

## Bitti kontrol listesi
- [ ] PRD 1 sayfa; veri türü ve kapsam dışı yazılı
- [ ] Şablon `projects/<ad>/` altında; gerçek veri yok
- [ ] Plan ≤ 7 adım; 1. adım ≤ 1 saat
- [ ] `make test` sonucu raporlandı
- [ ] Varsayımlar ve açık sorular listelendi

## Sık hatalar
- Gereksiz soru yağdırmak (en çok 4, çoğu zaman 0).
- Gerçek veri ile başlamak.
- Büyük plan; ilk adımı küçültmemek.
- Sözleşmeyi atlayıp doğrudan kod yazmak.
- Kök `apps/web`'i değiştirmek (kopyayı `projects/<ad>/` altında geliştir).

## İlgili
`/new-project` · `gsbpm-surec-haritasi` · `prompt-serisi` · `veri-adaptoru` · `go-api-endpoint` · `nextjs-sayfa-bilesen` · `templates/README.md` · `docs/egitim/06-proje-baslatma-akisi.md`
