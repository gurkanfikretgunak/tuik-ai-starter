# contracts

Web, Go ve Python arasında tek doğruluk kaynağı. API değişikliği önce burada başlar.

## Ne öğretir
Sözleşme-öncelikli geliştirme: önce şema, sonra kod (`docs/adr/0002-sozlesme-oncelikli-gelistirme.md`).

## Mevcut içerik (`openapi.yaml`, OpenAPI 3.0.3, sürüm 0.1.0)
| Uç | Yanıtlar |
|---|---|
| `GET /health` | 200 `{status}` |
| `GET /series/{code}` | 200 `Series`, 400/404 `Error` (`code` en çok 64 karakter) |
Şemalar: `Error`, `Observation` (`period`, `region`, `value` nullable, `status`: geçici/kesin/revize/gizli/tahmini), `Series`. Gizli hücrede `value` = `null`.

## Değişiklik akışı
1. `openapi.yaml`'ı düzenle (ikinci sözleşme dosyası açma).
2. Go: `/new-endpoint`; TS: `/regenerate-client`.
3. İstek koleksiyonu varsa genişlet (tek koleksiyon, tek ortam dosyası; sırlar boş).
4. `CHANGELOG.md` → `contracts:` ve `api:` satırı.

## Doğrulama
Dosyayı bir OpenAPI doğrulayıcıyla denetle (araç seçimi doğrulanmadı; projede hazır komut yok). En azından: `python3 -c "import yaml,sys; yaml.safe_load(open('packages/contracts/openapi.yaml'))"` (PyYAML kuruluysa).

## Dosya haritası
`openapi.yaml` · tüketiciler: `services/api`, `packages/api-client-ts`, `apps/web`, `compute`.
