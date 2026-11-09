# Yerel / küçük LLM ile çalışma rehberi

Bu rehber genel ilkelerdir. Belirli model adı, sürüm, hız veya doğruluk iddiası içermez; bunlar bu repoda doğrulanmadı.

## Ne zaman yerel model
| Durum | Karar |
|---|---|
| Girdi kamuya açıklanabilir (sentetik, açık kod) | Bulut veya yerel serbest |
| Girdi hassas (mikro veri, kişisel veri, gizli istatistik) | Buluta GİTMEZ. Yerel çözüm veya iş yapılmaz (`.claude/rules/01-veri-gizliligi.md`) |
| Görüntü işleme gerektiren hassas iş | Faz 2: `agents-local` (henüz aktif değil; `.claude/rules/vision-local.md`) |
| Emin değilsin | "Kamuya açıklanabilir mi?" sorusu: hayır say, `/ai-risk` çalıştır |

Dikkat: yerel model de depodaki hassas dosyaları okumamalıdır; hook'lar yalnızca Claude Code için geçerlidir. Yerel çalıştırıcıda aynı disiplini elle uygula. Hook'ların başka araçlarda çalıştığı: doğrulanmadı.

Yerel çalıştırıcı örnekleri (tür): Ollama, LM Studio, llama.cpp. Hangisinin bu projeye uygun olduğu donanım ve model seçimine bağlıdır; Faz 2 öncesi karar verilecek (`agents-local/README.md`).

## Yerel modelin sınırlılıkları (genel)
- Bağlam penceresi küçük olabilir: tüm repoyu veremezsin.
- Uzun, çok adımlı akıl yürütmede hata payı yüksek olabilir.
- Paket, API ve fonksiyon adı uydurabilir; her zaman çalıştırıp doğrula.
- Biçim talimatlarını (tablo, yalnızca kod) kaçırabilir; çıktı kalıbını örnekle ver.
Hepsi genel gözlemdir; belirli bir modelin davranışı doğrulanmadı.

## Bağlama hangi dosyaları besle (öncelik sırası)
Pencere sığdığı kadar, yukarıdan aşağı:
1. Görev prompt'u (hedef, kısıt, bitti tanımı).
2. `docs/baglam/01-proje-haritasi.md` ilgili katman bölümü (tamamı gerekmez).
3. Düzenlenecek dosya ve yanındaki test dosyası.
4. Doğrudan bağımlı arayüz: Go için `internal/domain/series.go`; web için `lib/data/types.ts`; Python için ilgili modülün imzaları.
5. Katman kuralı: `.claude/rules/backend-go.md`, `web-nextjs.md` veya `hesaplama-python.md`.
6. İlgili skill'in `SKILL.md` dosyası (gerekiyorsa).
7. `packages/contracts/openapi.yaml` (yalnızca API işi).
Verme: `package-lock.json`, `.cursor/`, `docs/egitim/`, tüm `.claude/rules/` seti.

## Kısa prompt kalıpları
```
Görev: <tek cümle>.
Dosya: <yol>.
Kural: <1-3 madde>.
Çıktı: yalnızca <dosya adı> için tam kod. Açıklama yazma.
```
```
Aşağıdaki fonksiyona <ValueError> hata yolu için pytest testi yaz. Yalnızca test dosyasını ver.
<fonksiyon>
```
Örnek ver: bir mevcut test dosyasını "bu stilde yaz" diye ekle (örn. `compute/tests/test_weights.py`).

## Adım adım görev bölme
1. Plan: "Kod yazma; değişecek dosyaları ve adımları listele."
2. Sözleşme/arayüz: yalnızca tip veya imza.
3. Tek dosya uygulaması.
4. Test dosyası.
5. Çalıştır ve hata çıktısını (sentetik) geri ver; düzelttir.
6. CHANGELOG satırı.
Her adım ayrı sohbet turu; her adımda en fazla 1-2 dosya.

## Doğrulama (testle)
| Katman | Komut |
|---|---|
| Go | `cd services/api && go test ./...` |
| Python | `cd compute && python -m pytest -q` |
| Web | `cd apps/web && npm test` |
| Hepsi (web hariç) | `make test` |
| Hassas içerik | `bash .claude/skills/kvkk-kontrol/scan.sh .` |
Model "çalışıyor" derse kabul etme; testi sen çalıştır. Test geçmiyorsa hata çıktısını yapıştır, tek hatayı düzelttir.

## Bitti kontrol listesi
- [ ] Veri sentetik; hassas girdi yok.
- [ ] Çıktı çalıştırıldı, testler geçti.
- [ ] Yeni paket varsa gerçekliği doğrulandı (yoksa "doğrulanmadı").
- [ ] Eşikler parametre; koda gömülmedi.
- [ ] `make lint` ve `make test` temiz.

## Sık hatalar
- Hassas veriyi "yerel nasılsa" diye rastgele araçlara vermek: önce sınıflandır.
- Tüm repoyu bağlama doldurmak: sonuç kalitesi düşer.
- Modelin uydurduğu fonksiyonu kabul etmek: harita ve `grep` ile doğrula.
- Tek turda çok dosya istemek.

## İlgili
`docs/baglam/01-proje-haritasi.md`, `docs/prompt-kutuphanesi.md`, `.claude/rules/01-veri-gizliligi.md`, `.claude/rules/vision-local.md`, `agents-local/README.md`, `docs/security/ai-kullanim-riskleri.md`.
