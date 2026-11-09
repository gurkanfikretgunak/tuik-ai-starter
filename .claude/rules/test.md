# Test standartları
- Her yeni davranış için en az bir başarılı yol ve bir hata yolu testi.
- Test isimleri davranışı anlatır. Gerçek veri kullanılmaz.
- Hata düzeltmede önce hatayı yeniden üreten test yaz.

## Test komutları
| Katman | Komut | Yer |
|---|---|---|
| Go | `cd services/api && go test ./...` | `*_test.go` |
| Python | `cd compute && python -m pytest -q` | `compute/tests/` |
| Web | `cd apps/web && npm test` (Vitest) | `*.test.ts(x)` |
| Hepsi (Go+Py) | `make test` | |

## Adlandırma (evet/hayır)
| Evet | Hayır |
|---|---|
| `test_percent_change_raises_on_zero_previous` | `test1`, `testFunc` |
| `it("returns null for unknown code")` | `it("works")` |

## Do / Don't
- DO: her davranış için başarılı yol + hata yolu. DO: hata düzeltmede önce hatayı yeniden üreten test.
- DO: sentetik veri (`data/sample/`). DON'T: gerçek veri, ağ/saat/rastgelelik bağımlılığı (seed sabit).
- DON'T: testi silerek/zayıflatarak geçir.
