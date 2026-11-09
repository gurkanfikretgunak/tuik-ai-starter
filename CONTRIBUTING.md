# Katkı

## Hızlı akış
1. Dal aç (varsayılan dalı tahmin etme: `gh repo view --json defaultBranchRef`).
2. Küçük, tek amaçlı değişiklik yap; önce plan, sonra kod, sonra test.
3. `make lint test test-hooks audit` (veya `/ship`).
4. PR aç: ne, neden, nasıl doğrulanır, risk.

## Kurallar
1. **Kapsam:** PR başına tek tutarlı değişiklik (`.claude/rules/03-commit-ve-pr.md`); ilgisiz refactor ayrı PR.
2. **Açıklama:** ne, neden, nasıl doğrulanır, risk; insan sesiyle kısa paragraflar.
3. **Kontroller:** `make lint test test-hooks audit`; `/ship` komutu bunları sırayla yürütür.
4. **Ship checklist:** `.claude/rules/04-ship-checklist.md` (sözleşme, CHANGELOG, sürüm).
5. **Yeni skill/rule/command/hook:** `docs/katki-rehberi.md`; hook eklerken test ve README güncelle.
6. **Veri:** gerçek veri, kişisel veri ve sır asla (bkz. `docs/security/ai-kullanim-riskleri.md`).

## Commit biçimi
`tip(kapsam): emir kipinde özet`. Tipler: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`. Kapsamlar: `web`, `api`, `compute`, `contracts`, `ai`, `docs`.
Örnek: `feat(web): seri sayfası eklendi` · `docs(changelog): 0.3.0 notları`.

## Katman başına kontrol
| Katman | Komut |
|---|---|
| Go | `cd services/api && go vet ./... && go test ./...` |
| Python | `cd compute && python -m pytest -q` |
| Web | `cd apps/web && npm test` |
| İstemci | `cd packages/api-client-ts && npm test` |
| Hook | `make test-hooks` |
Değişince `CHANGELOG.md` (`api:`, `web:`, `compute:`, `contracts:`, `ai:`) ve gerekirse `apps/web/package.json` sürümü.

## PR kontrol listesi
- [ ] Testler yeşil · [ ] Sözleşme güncel · [ ] CHANGELOG · [ ] Gerçek veri/sır yok · [ ] Bağımlılık değiştiyse `make audit`

Davranış kuralları: `CODE_OF_CONDUCT.md` · Güvenlik bildirimi: `SECURITY.md`.
