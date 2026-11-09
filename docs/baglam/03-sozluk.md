# Sözlük

Standart tanımlar. Kurumsal eşik ve yöntem kararları "kurum kararı" ile işaretlidir; bu repoda sabitlenmez.

## İstatistik terimleri
| Terim | Anlamı |
|---|---|
| GSBPM | Genel İstatistiksel İş Süreci Modeli. Aşamalar: ihtiyaç belirleme, tasarım, inşa, toplama, işleme, analiz, yayma, değerlendirme. Proje komutu: `/new-surec` |
| Mikro veri | Birim (kişi, hane, işyeri) düzeyi kayıt. Prompta, repoya, loga girmez |
| Sentetik veri | Gerçek kayıtlardan türemeyen, üretilmiş veri. `data/sample/` yalnızca bunu içerir |
| Anonim veri | Kimlik bilgisi çıkarılmış veri; tek başına güvenli sayılmaz, yeniden belirlenebilirlik riski vardır |
| İfşa (istatistiki ifşa kontrolü) | Yayımlanan tablodan tek bir birimin bilgisinin çıkarılabilmesi riskinin denetimi |
| Küçük hücre | Birim sayısı eşiğin altında olan hücre. Eşik: kurum kararı. Kod: `is_small_cell` |
| Baskınlık | Bir hücrede en büyük birim(ler)in payının eşiği aşması. Kod: `is_dominated` |
| İkincil bastırma | Gizlenen hücre toplamdan geri hesaplanmasın diye ek hücrenin gizlenmesi. Kod: `secondary_suppress` |
| Ağırlık | Örnekteki bir birimin kaç birimi temsil ettiği. Ağırlıklı toplam = toplam(değer x ağırlık) |
| Ağırlıklı ortalama | Ağırlıklı toplam / ağırlıkların toplamı |
| CV (değişim katsayısı) | Standart hata / tahmin. Genellikle yüzde verilir; kalite sınıfı eşikleri kurum kararı. Kod: `coefficient_of_variation` |
| Standart hata | Örnekleme kaynaklı tahmin belirsizliğinin ölçüsü |
| Endeks | Bir temel döneme göre oranlanmış ölçü (temel dönem = 100) |
| Zincirleme endeks | Dönemlik değişimlerin ardışık çarpılmasıyla bulunan endeks. Kod: `chain_index` |
| Laspeyres | Temel dönem ağırlıklı fiyat endeksi |
| Yüzde değişim | (güncel - önceki) / önceki x 100. Kod: `percent_change` |
| Geçici / kesin / revize | Verinin durumu. Web tipi `Durum`: geçici, kesin, revize, gizli, tahmini |
| Revizyon | Yayımlanmış verinin sonradan düzeltilmesi; işaretlenir ve sürüm notu yazılır |
| Embargo | Yayın zamanına kadar verinin dışarı verilmemesi kuralı |
| Metaveri | Verinin tanımı: ad, birim, periyot, kaynak, metodoloji |
| Periyot | Aylık, çeyreklik, yıllık |
| Editing / imputation | Hatalı verinin düzeltilmesi / eksik verinin tamamlanması (skill `veri-temizleme`) |
| Mevsimsel düzeltme | Mevsim etkisinin ayıklanması; bu repoda yöntem yok, doğrulanmış araç gerekir |

## Sınıflamalar
| Kısaltma | Anlamı |
|---|---|
| NACE | Ekonomik faaliyet sınıflaması (AB) |
| ISCO | Uluslararası meslek sınıflaması |
| COICOP | Bireysel tüketimin amaca göre sınıflaması |
| Sürümlü eşleme | Sınıflama sürümleri arası tablo; sürüm bilgisi saklanır (skill `siniflandirma-esleme`) |

Kesin sürüm numaraları ve Türkiye uyarlaması adları: doğrulanmadı; kurumun güncel kaynağına bak.

## Proje ve yapay zekâ terimleri
| Terim | Anlamı |
|---|---|
| Rule | `.claude/rules/*.md`; her zaman (veya yola göre) geçerli kısa kural |
| Skill | `.claude/skills/<ad>/SKILL.md`; konu uzmanlığı akışı, gerektiğinde yüklenir |
| Command | `.claude/commands/*.md`; `/ad` ile çağrılan hazır iş akışı |
| Agent | `.claude/agents/*.md`; belirli rolde, sınırlı araçlı yardımcı (planner, reviewer, test-writer, doc-writer, data-privacy-auditor) |
| Hook | `.claude/hooks/`; araç/prompt olaylarında otomatik çalışan denetim betiği. Engelleme veya uyarı üretir; atlatılmaz |
| MCP | Modelin dış araçlara bağlandığı protokol; `.mcp.json`. Hassas veri göndermeyin |
| Bağlam penceresi | Modelin bir seferde görebildiği metin miktarı |
| Prompt | Modele verilen görev metni |
| Brief | Hedef, bağlam, kısıt ve bitti tanımını içeren iş tarifi |
| DoD | Definition of Done; bitti kontrol listesi |
| Sözleşme (contract) | `packages/contracts/openapi.yaml`; API'nin tek tanımı |
| ADR | Mimari karar kaydı (`docs/adr/`) |
| KVKK | Kişisel Verilerin Korunması Kanunu |
| Yerel LLM | Kendi cihazında çalışan dil modeli (bkz. `docs/yerel-llm.md`) |
| Faz 2 | `agents-local` altındaki yerel görüntü işleme; henüz aktif değil |

## Sık hatalar
- "Anonim" demek ile "ifşa riski yok" demeyi karıştırmak.
- CV'yi yüzde/oran karıştırarak raporlamak.
- Kurum eşiğini sözlükteki bir değer sanmak: sözlük eşik vermez.

## İlgili
`01-proje-haritasi.md`, `.claude/rules/10-ifsa-kontrolu.md`, `.claude/rules/12-yayin-ve-revizyon.md`.
