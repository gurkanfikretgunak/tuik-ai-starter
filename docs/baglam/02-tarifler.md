# Tarifler: "şunu yapmak istiyorum" tablosu

Her satır: hedef, dokunulacak dosyalar, çalıştırılacak komut, kullanılacak skill/command. Varsayılan: önce plan (kısa), sonra kod, sonra test.

## Hızlı tablo
| İstek | Dosyalar (sırayla) | Komut | Skill / command |
|---|---|---|---|
| Yeni API endpoint | `packages/contracts/openapi.yaml` → `services/api/internal/domain/` → `application/<usecase>/usecase.go` → `handler/<ad>.go` → `NewMux()` içinde `handler/health.go` | `make test` | `/new-endpoint`, skill `go-api-endpoint` |
| Yeni web sayfası | `apps/web/src/app/<rota>/page.tsx`, gerekirse `apps/web/src/lib/` | `cd apps/web && npm test` | `/new-page`, skill `nextjs-sayfa-bilesen` |
| Yeni hesaplama | `compute/src/tuik_calc/<modul>.py`, `compute/tests/test_<modul>.py` | `cd compute && python -m pytest -q` | `/new-calc`, skill `py-hesaplama-modulu` |
| İfşa kontrolü | `compute/src/tuik_calc/disclosure.py` | `make test` | `/ifsa-kontrol`, skill `ifsa-kontrolu` |
| Yeni gösterge/seri tanımı | gösterge metaverisi, `data/sample/` | - | skill `istatistik-gostergesi` |
| Zafiyet tarama | `docs/security/zafiyet-kayitlari.md` | `make audit`, `make audit-list` | `/audit`, skill `zafiyet-takibi` |
| Sözleşme değişimi | `packages/contracts/openapi.yaml` → `packages/api-client-ts/src/` → web tüketicileri | `make test` | `/regenerate-client`, skill `api-client-ts` |
| Yeni proje | `templates/` | - | `/new-project`, skill `proje-baslat` |
| İstatistik işi planı | - | - | `/new-surec`, skill `gsbpm-surec-haritasi` |
| Endeks/değişim | `compute/src/tuik_calc/indices.py` | `make test` | skill `endeks-hesaplama` |
| Ağırlık, CV | `compute/src/tuik_calc/weights.py` | `make test` | skill `agirliklandirma-ornekleme` |
| Veri doğrulama kuralı | `compute/src/tuik_calc/validation.py` | `make test` | skill `veri-temizleme` |
| Grafik/dashboard | `apps/web/src/` | `cd apps/web && npm test` | skill `veri-gorsellestirme` |
| Türkçe arama kutusu | `apps/web/src/lib/tr-search.ts` | `cd apps/web && npm test` | skill `turkce-arama` |
| Yeni veri kaynağı | `apps/web/src/lib/data/` (yeni `SeriDataSource`, `index.ts` içinde bağla) | `cd apps/web && npm test` | skill `veri-adaptoru` |
| Sınıflama eşleme | NACE/ISCO/COICOP tabloları | - | skill `siniflandirma-esleme` |
| Kalite raporu | - | - | `/kalite-kontrol`, skill `kalite-raporu` |
| Yayın/revizyon | - | - | skill `yayin-ve-revizyon` |
| Gizlilik taraması | tüm değişiklik | `bash .claude/skills/kvkk-kontrol/scan.sh .` | skill `kvkk-kontrol` |
| Kod inceleme | `git diff` | - | `/review`, skill `kod-inceleme` |
| Bitirme | - | `make lint && make test` | `/ship` |
| Ortam sorunu | - | `make doctor` | - |
| Hook'ları sına | `.claude/hooks/` | `make test-hooks` | - |
| Cursor eşitle | `.claude/` | `make sync-cursor` | - |
| AI risk sorusu | `docs/security/ai-kullanim-riskleri.md` | - | `/ai-risk`, skill `ai-risk-degerlendirme` |

## Tarif A: yeni endpoint (ayrıntı)
1. `packages/contracts/openapi.yaml` içine yolu, parametreyi, 200 ve hata yanıtını yaz. Mevcut: `/health`, `/series/{code}`.
2. Varlık ve depo arayüzü gerekiyorsa `services/api/internal/domain/` içine ekle.
3. İş akışı: `services/api/internal/application/<ad>/usecase.go` (`New`, `Execute` kalıbı).
4. Handler: `services/api/internal/handler/<ad>.go`; hata için `writeErr(w, status, code, msg)`.
5. Rotayı `NewMux()` içine ekle.
6. Test: başarılı yol ve hata yolu. `make test`.
7. `CHANGELOG.md` içine `api:` satırı. İstemci tipi değiştiyse `/regenerate-client`.

## Tarif B: yeni sayfa
1. `apps/web/src/app/<rota>/page.tsx` oluştur; metinler Türkçe.
2. Veriyi `getDataSource()` ile al; bileşende kaynağı doğrudan çağırma.
3. Gizli hücre (`deger: null`) "gizli" gösterilir, sıfır gösterilmez.
4. Test ekle (`*.test.ts`). `apps/web/package.json` sürümünü MINOR artır (yeni sayfa); `CHANGELOG.md` `web:` satırı.

## Tarif C: yeni hesaplama
1. İmza ve docstring (örnek dahil) yaz, tip ipuçları kullan.
2. Girdiyi doğrula (aralık, uzunluk eşitliği); hatada `ValueError`.
3. Eşik/parametre dışarıdan gelsin (kurum kararı).
4. `compute/tests/test_<modul>.py`: normal, sınır ve hata durumu.
5. Formül eski sonuçları değiştiriyorsa MAJOR; `CHANGELOG.md` `compute:`.

## Tarif D: tablo yayımlamadan önce
1. Hücre sayısı eşiği: `is_small_cell(count, min_count)`.
2. Baskınlık: `is_dominated(values, top_n, max_share)`.
3. Bastırma: `suppress_row`, sonra `secondary_suppress` (toplam açıklanıyorsa).
4. Eşikleri kurumdan al; kodda sabitleme.
5. Çıktıda `gizli` işareti olduğunu test et.

## Tarif E: bağımlılık ekleme
1. Paketin gerçekten var olduğunu ve lisansını doğrula (doğrulanmadıysa ekleme).
2. `make audit`; bulguları `docs/security/zafiyet-kayitlari.md` içine `ZAF-YYYY-NNN`, sorumlu ve hedef tarihle işle.
3. PR'da bağımlılığın nedenini yaz.

## Varsayılanlar
| Eksik bilgi | Varsay |
|---|---|
| Veri | `data/sample/` sentetik veri |
| Dil | Kod İngilizce, metin Türkçe |
| Test | Bir başarılı, bir hata yolu |
| Eşik | Parametre olarak al, değer uydurma |

## Sık hatalar
- Sözleşmeyi güncellemeden handler yazmak.
- Test olmadan "bitti" demek.
- Gerçek veriyle denemek.

## İlgili
`01-proje-haritasi.md`, `04-komut-referansi.md`, `docs/prompt-kutuphanesi.md`.
