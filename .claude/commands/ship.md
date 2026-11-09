---
description: Test + lint + commit + PR hazırlığı
---
1. `make lint`, `make test`, `make test-hooks` çalıştır; bağımlılık değiştiyse `make audit`. Hata varsa düzelt.
2. `kvkk-kontrol` skill'i ile değişikliklerde hassas veri/sır olmadığını doğrula.
3. `.claude/rules/04-ship-checklist.md` maddelerini kontrol et (sözleşme, CHANGELOG, sürüm).
4. `.claude/rules/03-commit-ve-pr.md` formatında commit mesajı öner.
5. PR açıklaması taslağı (insan sesiyle) yaz: ne, neden, nasıl test edildi.
Kullanıcı onaylamadan push etme.
