# Bitirme (ship) kontrol listesi
Bir iş, ilgili katmanın aşağıdaki maddeleri yapılmadan **bitmiş sayılmaz**.

## Backend (`services/**`) — API veya ortam sözleşmesi değiştiyse
1. `packages/contracts/openapi.yaml` güncel (tek sözleşme dosyası; yanına ikinci bir sözleşme dosyası açma).
2. API istek koleksiyonu varsa (`services/api/requests/` veya Postman) **tek koleksiyon + tek ortam dosyası** genişletilir; sırlar boş/örnek değerdir.
3. Kök `CHANGELOG.md` güncellenir: `### Eklendi / Değişti / Düzeltildi`, satır öneki `api:`.
4. İç refactor ve gözlemlenebilir değişiklik yoksa 2'yi atla; 3'ü yalnızca sürüm notuna değerse yaz.

## Web (`apps/web/**`) — kullanıcıya görünür değişiklik
1. `apps/web/package.json` sürümü artırılır (bkz. `05-surumleme.md`).
2. Kullanıcıya görünen metinler **TR** (zorunlu) ve proje EN istiyorsa **EN** olarak eklenir.
3. API kullanımı sözleşmeyle uyumlu; `CHANGELOG.md` notu `web:` önekiyle.

## Hesaplama (`compute/**`)
1. Formül/metodoloji değiştiyse docstring ve `CHANGELOG.md` (`compute:`) güncellenir.
2. Eski sonuçları etkileyen değişiklik **MAJOR** kabul edilir ve PR'da açıkça yazılır.

## Herkes için
- `make lint` + `make test` temiz, `kvkk-kontrol` temiz (`make kvkk` HATA vermez).

## Hızlı karar tablosu
| Değişiklik | Zorunlu adımlar |
|---|---|
| Yeni endpoint | openapi.yaml → handler/test → `api:` CHANGELOG → istemci (`/regenerate-client`) |
| İç refactor (davranış aynı) | Test + lint; CHANGELOG yok |
| Yeni sayfa | package.json MINOR + TR metin + `web:` CHANGELOG |
| Metin/stil düzeltmesi | package.json PATCH + `web:` CHANGELOG |
| Formül değişti | Docstring + `compute:` CHANGELOG; sonuç etkileniyorsa MAJOR |
| Yalnızca doküman | Sürüm artmaz |

## Do / Don't
- DO: sırayla yap: sözleşme → kod → test → lint → CHANGELOG → sürüm. DON'T: sürümü elle arayüze yaz.
- DO: yayımlanacak tabloyu `ifsa-kontrolu`'ndan geçir. DON'T: ifşa kontrolsüz yayım.
- DON'T: yanına ikinci sözleşme dosyası veya ikinci istek koleksiyonu açma.
- Son komutlar: `make lint && make test`; sonra `kvkk-kontrol` (`/ship` akışı hepsini toplar).
