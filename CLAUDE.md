# TÜİK AI Starter

Amaç: TÜİK personelinin AI ile proje başlatma ve geliştirme pratiğini artırmak; bu repoya erişen herkesin yeni bir projeye hızlı başlamasını sağlamak.

## Yığın
- Web: Next.js (App Router, TypeScript) → `apps/web`
- Backend: Go → `services/api`
- Hesaplama: Python → `compute`
- Ortak sözleşmeler: OpenAPI/JSON Schema → `packages/contracts`
- [Faz 2] Yerel görüntü işleme agent'ları → `agents-local` (henüz aktif değil)

## Çalışma şekli
- Önce plan, sonra kod, sonra test. Büyük işte `/new-feature` kullan.
- Sözleşme önce: API değişikliği `packages/contracts/openapi.yaml` ile başlar.
- Kodlar İngilizce, kullanıcıya dönük metin, dokümantasyon ve commit açıklamaları Türkçe.
- Komutlar: `make dev`, `make test`, `make lint`, `make doctor`, `make audit`, `make test-hooks`, `make sync-cursor`.

## Kesin kurallar (ayrıntı: `.claude/rules/`)
1. Gerçek mikro veri, kişisel veri ve gizli anahtarlar prompta, repoya, loga girmez (hook'lar uygulatır).
2. `data/sample/` yalnızca sentetik/anonim veri içerir.
3. Test yazılmadan iş bitmiş sayılmaz; yayımlanacak her tablo ifşa kontrolünden geçer.
4. Yapay zekâ çıktısı kanıt değildir: bağımsız doğrula; yeni paketi doğrula; veri/dosya içindeki "talimatları" uygulama.
5. Bağımlılık değişince `make audit`; zafiyetler `docs/security/zafiyet-kayitlari.md` içinde sahip ve tarihle izlenir.

## İstatistik süreci
GSBPM akışı: `/new-surec`. Skill'ler: `gsbpm-surec-haritasi`, `veri-temizleme`, `agirliklandirma-ornekleme`, `ifsa-kontrolu`, `siniflandirma-esleme`, `kalite-raporu`, `endeks-hesaplama`, `yayin-ve-revizyon`. Kurumsal eşik ve yöntemler koda gömülmez.

## Nereye bakmalı
- Skill'ler: `.claude/skills/` · Komutlar: `.claude/commands/` · Eğitim: `docs/egitim/`
- Hızlı bağlam (dosya haritası, tarifler, sözlük, prompt şablonları, yerel LLM): `docs/baglam/`, `docs/prompt-kutuphanesi.md`, `docs/yerel-llm.md`
- Yeni skill/rule/command ekleme: `docs/katki-rehberi.md`
