---
description: Test + lint + commit + PR hazırlığı
---
Argüman almaz. İşi teslime hazırlar: doğrulama, commit mesajı, PR taslağı. Kullanıcı onaylamadan push etme.

## Ne zaman
Bir iş bittiğinde, commit/PR açmadan önce.

## Girdiler ve varsayılanlar
| Konu | Varsayılan |
|---|---|
| Commit türü | Tür 1: `tip(kapsam): emir kipinde özet` |
| Varsayılan dal | `gh repo view --json defaultBranchRef` ile öğren; tahmin etme |
| Bağımlılık değişti mi | `git diff` içinde `go.mod`, `package.json`, `pyproject.toml` bak |
| Dil | Commit/PR Türkçe, tip İngilizce |

## Kullanılan skill/kural
`kvkk-kontrol`; kurallar: `.claude/rules/04-ship-checklist.md`, `03-commit-ve-pr.md`, `05-surumleme.md`, `14-zafiyet-takibi.md`.

## Adımlar
1. `make lint`, `make test`, `make test-hooks` çalıştır; hata varsa düzelt.
2. Bağımlılık değiştiyse `make audit`; yeni bulguları `docs/security/zafiyet-kayitlari.md` içine işle.
3. `kvkk-kontrol` ile hassas veri/sır olmadığını doğrula.
4. Ship checklist: sözleşme (`packages/contracts/openapi.yaml`), `CHANGELOG.md` (`api:`/`web:`/`compute:`), web sürümü.
5. Commit mesajı öner: `feat(web): seri sayfası eklendi` (türler: feat, fix, docs, test, refactor, chore; kapsamlar: web, api, compute, contracts, ai, docs).
6. PR taslağı (insan sesiyle, kısa paragraflar): ne, neden, nasıl doğrulanır, risk/geri alma.
7. Kullanıcıdan onay bekle; sonra commit/push.

## Çıktı biçimi
Komut sonuçları (geçti/kaldı) → checklist durumu → commit mesajı → PR taslağı.

## Örnek
`/ship` → lint/test/hook testleri temiz, CHANGELOG `web:` eklendi, mesaj `feat(web): raporlar sayfası eklendi`, PR taslağı.

## Bitti kontrol listesi
- [ ] lint, test, hook testleri temiz.
- [ ] `kvkk-kontrol` temiz.
- [ ] CHANGELOG/sürüm/sözleşme güncel.
- [ ] Commit ve PR metni hazır; push onayı alındı.

## Sık hatalar
- Hedef dalı tahmin etmek.
- Ek ilgisiz refactor'ü aynı PR'a sokmak.
- Onaysız push.
