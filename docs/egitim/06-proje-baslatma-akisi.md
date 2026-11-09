# 6. Proje başlatma akışı
**Seviye:** Orta · **Süre:** 60 dk

## Öğrenme hedefi
Fikirden çalışan iskelete tutarlı sırayla gitmek: **fikir → PRD → şablon → sözleşme → plan → ilk küçük özellik → test → `/ship`**.

## Akış
| # | Adım | Çıktı |
|---|---|---|
| 1 | `/new-project <ad> <şablon>` | PRD taslağı, dizin |
| 2 | Şablon seç | `templates/` altından (bkz. `templates/README.md`) |
| 3 | Sözleşme | `packages/contracts/openapi.yaml` güncel |
| 4 | Plan | Küçük, numaralı adımlar |
| 5 | İlk küçük özellik | Tek endpoint veya tek sayfa |
| 6 | Test | Başarılı + hata yolu |
| 7 | `/ship` | `make lint test test-hooks audit` |

Şablon seçimi: yalnız API → `go-service`; yalnız hesaplama → `py-calculation`; yalnız arayüz → `web-dashboard`; hepsi → `fullstack-minimal`.

## Adım adım alıştırma (`examples/04-uctan-uca-mini-proje`)
1. `/new-project mini-gosterge fullstack-minimal`
2. PRD'de kullanıcı, veri (sentetik), ilk gösterge ve kabul ölçütünü yazın; sorulmayan her şeyi varsayım olarak işaretleyin.
3. `openapi.yaml`'a bir ucu ekletin (`/new-endpoint`), sonra Go endpoint, Python hesap (`/new-calc`), Next.js sayfa (`/new-page`).
4. Her adımdan sonra ilgili test: `cd services/api && go test ./...`, `cd compute && python -m pytest -q`, `cd apps/web && npm test`.
5. `/review`, sonra `/ship`.

## Örnek prompt'lar
**Kötü:** `Bir proje başlat.`
**İyi:**
```
/new-project mini-gosterge fullstack-minimal
Amaç: tek bir göstergenin aylık serisini gösteren uygulama. Veri: yalnızca sentetik (data/sample/).
İlk dilim: GET /series/{code} + çizgi grafik sayfası. Belirsizlikte varsayım yaz, devam et.
Önce PRD ve plan ver, onayımı bekle.
```

## Kontrol soruları
1. Sözleşme neden koddan önce gelir? (`docs/adr/0002-sozlesme-oncelikli-gelistirme.md`)
2. İlk dilim neden "küçük" olmalı?
3. Backend ve web birlikte değişirse hangisi önce yayına gider? (Backend; `docs/runbooks/release-checklist.md`)

## İlgili
`.claude/skills/proje-baslat` · `.claude/skills/prompt-serisi` · `examples/05-prompt-serisi`
