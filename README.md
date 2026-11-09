# TÜİK AI Starter

TÜİK personelinin AI ile proje başlatma ve geliştirme pratiğini artırmak için hazırlanmış başlangıç reposu. Skill, rule, komut ve agent'lar hazır gelir; yeni bir projeye dakikalar içinde başlarsınız.

## 5 dakikada başla
```bash
make doctor          # ortam kontrolü
claude               # Claude Code'u repo kökünde aç
/new-project <ad>    # yeni proje başlat
/learn prompt        # kısa eğitim
```

## Yapı
| Klasör | Amaç |
|---|---|
| `.claude/rules` | Her zaman uyulacak kurallar (veri gizliliği dahil) |
| `.claude/skills` | Gerektiğinde yüklenen uzmanlık paketleri |
| `.claude/commands` | `/new-project`, `/new-feature`, `/review`, `/ship` ... |
| `.claude/hooks` | Otomatik güvenlik ağı: veri/sır engeli, komut ve paket denetimi, kod risk taraması |
| `docs/security` | Zafiyet kayıtları ve yapay zekâ kullanım riskleri |
| `.claude/agents` | planner, reviewer, test-writer, data-privacy-auditor, doc-writer |
| `apps/web` | Next.js |
| `services/api` | Go |
| `compute` | Python hesaplama |
| `packages/contracts` | Ortak API/şema sözleşmeleri |
| `templates` | Yeni proje şablonları |
| `examples` | Öğretici örnekler |
| `docs/egitim` | AI kullanım müfredatı |
| `agents-local` | **[Faz 2]** Yerel görüntü işleme agent'ları |

## Önemli
Gerçek veri, kişisel veri ve sırlar prompta ve repoya girmez. Ayrıntı: `.claude/rules/01-veri-gizliligi.md`.

## Faz durumu
- **Faz 1 (aktif):** web, backend, hesaplama, skill/rule/command altyapısı, eğitim
- **Faz 2 (planlı):** yerel görüntü işleme agent'ları, `agents-local/`
