# Değişiklik günlüğü
Biçim: sürüm/tarih + `### Eklendi / Değişti / Düzeltildi`; satır öneki `api:`, `web:`, `compute:`, `contracts:`, `ai:`.

## [0.2.1] - 2026-11-09
### Eklendi
- ai: `docs/baglam/` (proje haritası, tarifler, sözlük, komut referansı), `docs/prompt-kutuphanesi.md`, `docs/yerel-llm.md`
- ai: `proje-baslat/templates/plan.md`
### Değişti
- ai: tüm skill, komut, agent, kural ve modül CLAUDE.md dosyaları varsayılan, adım, şablon, örnek ve kontrol listesiyle genişletildi (az prompt / yerel LLM uyumu)
- ai: `AGENTS.md` koşullu yetenek yönlendirme (klasöre/göreve göre skill, rule, komut zinciri ve okuma bütçesi); `AGENTS_BASE_VERSION` 1.3.0
- docs: eğitim, ADR, runbook, şablon ve örnek README'leri genişletildi; kök README yenilendi

## [0.2.0] - 2026-11-09
### Eklendi
- ai: hook'lar — prompt-guard, command-guard, post-write-scan, session-start-uyari, stop-hatirlatma; `make test-hooks`
- ai: zafiyet takibi (`scripts/vuln-track.py`, `docs/security/zafiyet-kayitlari.md`), `docs/security/ai-kullanim-riskleri.md`
- ai: istatistik süreç skill'leri (gsbpm, veri-temizleme, agirliklandirma, ifsa, siniflandirma, kalite, endeks, yayin) ve rule'ları 08–14
- compute: weights, disclosure, validation modülleri
- api: katmanlı yapı + `/series/{code}`; contracts: Series şeması
- web: veri adaptörü, `tr-search`; packages: `api-client-ts`
### Değişti
- ai: commit/PR, ship checklist, sürümleme rule'ları

## [0.1.0] - 2026-11-09
### Eklendi
- İlk iskelet: rules, skills, commands, agents, Go/Python/Next.js başlangıcı
