# ADR 0001: Monorepo ve teknoloji yığını
**Durum:** Kabul · **Tarih:** 2026-11-09

## Bağlam
Farklı birimlerin hızlı proje başlatması ve AI araçlarını ortak kurallarla kullanması isteniyor. Üç farklı iş türü var: arayüz, servis, istatistiksel hesaplama. Kural, skill ve hook'ların tek yerde yaşaması gerekiyor.

## Karar
Tek monorepo:
| Katman | Teknoloji | Yer |
|---|---|---|
| Web | Next.js (App Router, TypeScript) | `apps/web` |
| Backend | Go | `services/api` |
| Hesaplama | Python | `compute` (`tuik_calc`) |
| Sözleşme | OpenAPI | `packages/contracts/openapi.yaml` |
| TS istemci | el yazımı | `packages/api-client-ts` |
| AI altyapısı | kural, skill, komut, hook | `.claude/` |
| Yerel agent'lar (Faz 2) | — | `agents-local` |

## Alternatifler
- Katman başına ayrı repo: kural ve skill paylaşımı zorlaşır, sürüm farkı büyür.
- Tek dil (yalnız TS veya Python): hesaplama ve servis ihtiyaçlarına uymaz.

## Sonuçlar
- Ortak kurallar tek yerde; path-scoped rule'lar (`paths:`) bağlamı hafif tutar.
- Her katmanın kendi test komutu vardır (`make test`); CI bunları birlikte çalıştırmalıdır.
- Repo büyürse şablon (`templates/`) ve katman başına `CLAUDE.md` yük dağıtır.
- Geri alma: katmanı ayrı repoya taşımak mümkündür; sözleşme paketi ayrı kalır.

## İlgili
`CLAUDE.md` · `docs/mevcut-projelerden-alinanlar.md`
