# apps/web (Next.js)
Yeni sayfa/bileşen: `/new-page`. Çalıştır: `npm install && npm run dev`. Test: `npm test`. Arayüz Türkçe, `tr-TR` biçimleri.

## Dizin haritası
| Yol | İçerik |
|---|---|
| `src/app/layout.tsx`, `page.tsx` | App Router kökü |
| `src/lib/format.ts` | `tr-TR` sayı/tarih biçimleri (+ `format.test.ts`) |
| `src/lib/tr-search.ts` | Türkçe karakter duyarsız arama (+ test) |
| `src/lib/data/{index,types,sample-source}.ts` | veri adaptörü: `getDataSource()`, `DATA_SOURCE` |
| `package.json` | tek sürüm kaynağı; script: `dev`, `build`, `start`, `lint`, `test` |
| örnek ortam dosyası (`.example` uzantılı) | gerçek değer içermez |

## Komutlar
`cd apps/web && npm install && npm run dev` · Test: `npm test` (Vitest) · Tip: `npx tsc --noEmit` · Yeni sayfa: `/new-page`.

## Adlandırma ve test deseni
- Bileşen `PascalCase.tsx`, yardımcı `kebab-case.ts`; test yanında `*.test.ts(x)`. Sunucu bileşeni varsayılan.
- Test: başarılı yol + hata/boş durum; sentetik veri.

## Yaygın görev → dosya
| Görev | Yap |
|---|---|
| Yeni sayfa | `src/app/<rota>/page.tsx` + package.json MINOR + TR metin + CHANGELOG `web:` |
| Veri okuma | `getDataSource()` üzerinden; bileşenden doğrudan çekme |
| Gerçek kaynağa geçiş | `src/lib/data/` altına yeni `SeriDataSource`, `index.ts`'de bağla |
| Arama/süzme | `tr-search.ts` |
| Sayı/tarih gösterimi | `format.ts` |
Kurallar: `.claude/rules/web-nextjs.md`, `05-surumleme.md`, `10-ifsa-kontrolu.md`.
