---
description: Plan → kod → test akışıyla yeni özellik geliştir
argument-hint: <özellik açıklaması>
---
Özellik: $ARGUMENTS

## Ne zaman
Birden çok dosya/katman etkileyen her yeni özellikte (küçük tek dosya düzeltmesi için gerekmez).

## Argüman sözdizimi ve varsayılanlar
`/new-feature <özellik açıklaması>` — örn. `/new-feature il bazlı seri listesi sayfası ve API ucu`.

| Eksik girdi | Varsayım |
|---|---|
| Katmanlar | Açıklamadan çıkar (web / api / compute) |
| Veri | Sentetik (`data/sample/`) |
| Dil | Kod İngilizce, arayüz metni TR |
| Plan onayı | Zorunlu; onay gelmeden kod yazma |

## Kullanılan skill/agent
Agent: `planner`, `test-writer`, `reviewer`. Skill'ler katmana göre: `go-api-endpoint`, `nextjs-sayfa-bilesen`, `py-hesaplama-modulu`, `api-client-ts`, `kvkk-kontrol`, `ifsa-kontrolu`. Kurallar: `.claude/rules/04-ship-checklist.md`, `06-mimari-katmanlar.md`, `test.md`.

## Adımlar
1. `planner` agent'ı ile plan çıkar (amaç, etkilenen dosyalar, sözleşme değişikliği, 3–7 adım, riskler, test stratejisi). **Kullanıcıdan onay iste.**
2. API etkileniyorsa önce `packages/contracts/openapi.yaml` güncelle.
3. Testleri yaz (başarılı + hata yolu); gerekirse `test-writer` kullan.
4. Uygula: sırayla backend → istemci (`/regenerate-client`) → web.
5. `make lint` ve `make test` çalıştır; web için `cd apps/web && npm test`.
6. `reviewer` agent'ı ile incele; Kritik/Önemli bulguları düzelt.
7. Ship checklist maddelerini uygula (sürüm, `CHANGELOG.md`). Commit için `/ship`.

## Çıktı biçimi
Plan özeti → değişen dosyalar → test sonucu → inceleme bulguları ve durumu → kalan riskler.

## Örnek
`/new-feature seri listesi sayfası` → plan (sözleşme + `GET /v1/seriler` + `/seriler` sayfası), onay, uygulama, `reviewer` raporu.
`/new-feature CV hesaplama` → yalnızca compute; sözleşme adımı atlanır, gerekçesi yazılır.

## Bitti kontrol listesi
- [ ] Plan onaylandı.
- [ ] Sözleşme önce güncellendi (gerekliyse).
- [ ] Testler yazıldı ve geçiyor; lint temiz.
- [ ] `reviewer` bulguları kapandı.
- [ ] CHANGELOG ve sürüm (web) güncellendi.

## Sık hatalar
- Onay almadan kod yazmak.
- Testleri sona bırakmak.
- Web'i API'den önce yayına planlamak (önce API).
