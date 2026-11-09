# Örnek 4: Uçtan uca mini proje

## Ne öğretir
Fikirden yayına hazır küçük bir dilime tüm akışı: PRD → sözleşme → Go endpoint → Python hesap → Next.js sayfa → inceleme → ship.

## Önkoşul
`make doctor` temiz; `apps/web` için `npm install`.

## Çalıştırma
```
/new-project mini-gosterge fullstack-minimal
```
Sonra sırayla: `/new-endpoint`, `/new-calc`, `/new-page`, `/review`, `/ship`. Her adımdan sonra:
```bash
cd services/api && go test ./...
cd compute && python -m pytest -q
cd apps/web && npm test
make lint test test-hooks audit
```

## Beklenen çıktı
PRD, güncel `openapi.yaml`, çalışan endpoint + hesap + sayfa, yeşil testler, `CHANGELOG.md` satırları (`api:`, `compute:`, `web:`) ve PR açıklaması.

## Dosya haritası
`templates/fullstack-minimal/` (kaynak parçalar) · `projects/mini-gosterge/` (üretilen) · `docs/egitim/06-proje-baslatma-akisi.md`.
