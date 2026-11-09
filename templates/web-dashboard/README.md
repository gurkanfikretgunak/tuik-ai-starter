# Şablon: web-dashboard

Kopyalanacak parça: `apps/web` + `veri-gorsellestirme` skill'i (`.claude/skills/veri-gorsellestirme`).

## Ne öğretir
Next.js App Router ile Türkçe, erişilebilir gösterge sayfası; veri adaptörü ile örnekten gerçek kaynağa geçiş.

## Önkoşul
Node.js + npm.

## Çalıştırma
```bash
cd apps/web && npm install
cd apps/web && npm run dev      # http://localhost:3000
cd apps/web && npm test         # vitest
cd apps/web && npm run build
```
Beklenen: sayfa açılır; testler yeşil. Veri kaynağı `DATA_SOURCE` (varsayılan `sample`).

## Dosya haritası
| Yol | İçerik |
|---|---|
| `src/app/layout.tsx`, `page.tsx` | kabuk ve ana sayfa |
| `src/lib/data/` | `SeriDataSource`, `sample-source.ts`, `getDataSource()` |
| `src/lib/tr-search.ts` | `foldTr`, `matchesTr`, `highlightTr` |
| `src/lib/format.ts` | `formatNumber` (`tr-TR`) |

Tasarım kararları: `docs/tasarim/DESIGN.template.md` → `DESIGN.md`. Yeni sayfa: `/new-page`. Örnek: `examples/01-ilk-prompt-ile-sayfa`.
