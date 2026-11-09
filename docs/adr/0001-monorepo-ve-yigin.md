# ADR 0001: Monorepo ve teknoloji yığını
**Durum:** Kabul · **Tarih:** 2026-11-09

**Bağlam:** Farklı birimlerin hızlı proje başlatması ve AI araçlarını ortak kurallarla kullanması isteniyor.
**Karar:** Tek monorepo; web Next.js, backend Go, hesaplama Python; ortak sözleşmeler `packages/contracts`; AI altyapısı `.claude/` altında.
**Alternatifler:** Katman başına ayrı repo (kural ve skill paylaşımı zorlaşır).
**Sonuçlar:** Ortak kurallar tek yerde; repo büyüdükçe path-scoped rule'lar bağlamı hafif tutar.
