# Playbook: yeni göstergeyi uçtan uca yayımlama

**Ne zaman:** Yeni bir istatistik serisi hesaplanıp API ve web üzerinden yayımlanacak.
**Süre/dilim:** Her adım ayrı küçük PR olabilir; sıra önemlidir (önce API, sonra istemci).

## Adımlar
| # | Adım | Komut / skill | Çıktı |
|---|---|---|---|
| 1 | Göstergeyi tanımla (kod, ad TR/EN, birim, periyot, kaynak, yöntem) | `istatistik-gostergesi` | gösterge metaverisi |
| 2 | Süreci GSBPM'e eşle | `/new-surec` | aşama–çıktı tablosu |
| 3 | Hesaplamayı yaz ve test et (sentetik veriyle) | `/new-calc` | `compute/src/tuik_calc/*.py` + test |
| 4 | Veriyi doğrula/temizle | `veri-temizleme` | doğrulama kuralları geçti |
| 5 | Sözleşmeyi güncelle | `packages/contracts/openapi.yaml` | uç ve şema |
| 6 | Endpoint ekle | `/new-endpoint` | handler + test + CHANGELOG `api:` |
| 7 | İstemciyi eşitle | `/regenerate-client` | `packages/api-client-ts` |
| 8 | Sayfa/grafik ekle | `/new-page`, `veri-gorsellestirme` | `apps/web/src/app/...`, sürüm artışı |
| 9 | İfşa kontrolü | `/ifsa-kontrol` | gizli hücreler `"gizli"` işaretli |
| 10 | Kalite raporu ve yayın durumu | `/kalite-kontrol`, `yayin-ve-revizyon` | rapor, durum bayrakları |
| 11 | Teslim | `/ship` | lint + test + PR |

## Bitti kontrol listesi
- [ ] Gerçek veri yok; örnekler sentetik.
- [ ] Eşikler parametre (kurum kararı), koda gömülü değil.
- [ ] Yayımlanan her tablo ifşa kontrolünden geçti.
- [ ] `CHANGELOG.md` (`api:`, `web:`, `compute:`) ve web sürümü güncel.
- [ ] `make lint` ve `make test` temiz.

## Sık hatalar
- Sözleşmeden önce handler yazmak → önce `openapi.yaml`.
- Gizli hücreyi `0` veya boş bırakmak → `"gizli"` / `status: gizli`.
