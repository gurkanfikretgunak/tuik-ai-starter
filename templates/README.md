# Şablonlar

`/new-project <ad> <şablon>` bu şablonlardan türetir. Şu an `fullstack-minimal`, kökteki `apps/web`, `services/api`, `compute` iskeletini referans alır; diğerleri ilgili parçanın tek başına kopyasıdır. Şablon dizinleri şu an yalnızca README içerir; kopyalanacak gerçek kod kökteki dizinlerdedir.

## Ne öğretir
Yeni projeye hangi parçalarla başlanacağını ve parçaların birbirine nasıl bağlandığını (sözleşme → servis → hesaplama → arayüz).

## Hangi şablonu seçmeli
| İhtiyaç | Şablon | Kaynak dizin |
|---|---|---|
| Arayüz + API + hesaplama | `fullstack-minimal` | `apps/web`, `services/api`, `compute`, `packages/contracts` |
| Yalnız API | `go-service` | `services/api`, `packages/contracts` |
| Yalnız hesaplama | `py-calculation` | `compute` |
| Yalnız arayüz | `web-dashboard` | `apps/web` + skill `veri-gorsellestirme` |
Emin değilsen: `fullstack-minimal`.

## Önkoşul
`make doctor` çıktısında `git node npm go python3 make` için `OK`.

## Kullanım
```bash
# Claude Code içinde
/new-project mini-gosterge fullstack-minimal
```
Beklenen: PRD taslağı + seçilen şablondaki parçaların `projects/<ad>/` altına yerleşmesi; ardından sözleşme ve plan adımı.

## Dosya haritası
```
templates/
  README.md
  fullstack-minimal/README.md
  go-service/README.md
  py-calculation/README.md
  web-dashboard/README.md
```
Eğitim: `docs/egitim/06-proje-baslatma-akisi.md` · Örnek: `examples/04-uctan-uca-mini-proje`.
