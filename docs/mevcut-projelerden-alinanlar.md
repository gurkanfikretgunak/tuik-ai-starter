# Mevcut projelerden alınan pratikler
Bu starter, aynı klasördeki projelerin pratiklerinden (salt okunur incelenerek) uyarlanmıştır. Amaç: aynı şeyi yeniden icat etmemek ve nereden geldiğini izlenebilir tutmak.

| Kaynak proje | Alınan | Starter'daki yeri |
|---|---|---|
| masterfabric-core-base | `AGENTS_BASE_VERSION`, commit türleri, PR hijyeni, varsayılan dal kuralı | `AGENTS.md`, rule `03` |
| masterfabric-core-base | Go katmanları (Execute deseni, sentinel hatalar) | rule `06`, `services/api/internal/*` |
| masterfabric-core-base | Ship checklist (tek koleksiyon + CHANGELOG), sürüm artırma | rule `04`, `05` |
| masterfabric-core-base | Paylaşımlı ortam veri kuralları, release checklist, ADR'ler | `docs/runbooks/`, `docs/adr/` |
| masterfabric-core-base | El yazımı TS istemcisi + skill | `packages/api-client-ts`, skill `api-client-ts` |
| masterfabric-core-base | MCP kullanımı, geçit (gateway) ilkesi | rule `07` |
| masterfabric-core-base | `.cursor/` rules/commands/skills | `scripts/sync-cursor.py` |
| masterfabric-mac-cli | Gizlilik/cihaz-üstü ilkeleri, sır yönetimi | rule `02`, `vision-local` (Faz 2) |
| sirket-sicil | Veri adaptörü, Türkçe arama, DESIGN.md, Next.js "güncel doküman oku" notu | skill `veri-adaptoru`, `turkce-arama`, `tasarim-dokumani`, rule `web-nextjs` |
| _meta-sicil | Numaralı prompt serisi yöntemi | skill `prompt-serisi`, `examples/05` |

## Nasıl kullanılır
1. Bir pratiği değiştirmeden önce tablodan yerini bul, ilgili rule/skill'i oku.
2. Kaynak projeden yeni bir pratik alacaksan: salt okunur incele, kopyalama yerine uyarla, bu tabloya satır ekle.
3. Gerçek veri, anahtar ve markaya özgü içerik taşıma.

## Kopyalanmayanlar
Kurumsal lisans (AGPL) ve markaya özgü içerik — TÜİK için lisans/sahiplik kararı kurumca verilmelidir (doğrulanmadı; hukuk birimine danışılmalı).

## İlgili
`docs/adr/` · `docs/katki-rehberi.md`
