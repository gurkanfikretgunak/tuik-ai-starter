---
name: prompt-serisi
description: Büyük bir uygulamayı sıralı, numaralı promptlarla (prompt1…N) adım adım inşa etme yöntemi. Sıfırdan uygulama kurarken ve eğitimde "AI ile proje nasıl büyütülür" gösterilirken kullan.
---
# Prompt serisi yöntemi

## Ne zaman
Tek promptta bitmeyecek büyüklükte uygulama (arama + detay + tasarım + test + doküman) kurulurken; küçük/yerel modelle çalışırken (her adım küçük ve bağlamı kısa). (`_meta-sicil` çalışmasından uyarlanmıştır.)

## Girdiler ve varsayılanlar
| Girdi | Varsayılan |
|---|---|
| Adım sayısı | 6 (aşağıdaki iskelet) |
| Yığın | Next.js (`apps/web`), gerekirse Go/Python |
| Veri | sentetik; `scripts/generate-sample-data.mjs` (seed 42) |
| Tasarım | `DESIGN.md` (`tasarim-dokumani`) |
| Her adım sonu | çalıştır → test → `git commit` |
| Günlük | `run*.log` repoya değil yerel `.claude/logs/` klasörüne (git'e girmez) |
| Dil | arayüz Türkçe |

Sorma; alan adını ve veri türünü kullanıcının isteğinden çıkar.

## Adımlar (iskelet)
1. **Prompt 1 — Kurulum ve veri katmanı:** çalışma dizini, yığın, tip tanımı, veri adaptörü (`veri-adaptoru`), **sentetik** seed'li üretici.
2. **Prompt 2 — Çekirdek özellik:** arama/liste (`turkce-arama`), sunucu tarafı indeks.
3. **Prompt 3 — Detay ekranı:** kimlik çipleri, durum rozetleri, `geçici/kesin`, `gizli` gösterimi.
4. **Prompt 4 — Tasarım cilası:** `DESIGN.md` ile uyum, boş/hata/yükleniyor durumları.
5. **Prompt 5 — Erişilebilirlik ve test:** kontrast, klavye, etiketler, Vitest.
6. **Prompt 6 — Doküman:** README, örnek veri uyarısı, `/ship`.

Her promptun yapısı: **Bağlam** (dizin, önceki çıktı) → **Hedef** → **Kısıtlar** (yığın, sentetik veri, Türkçe arayüz) → **Kabul ölçütü** (komut ve beklenen sonuç).

Döngü: promptu ver → çıktıyı çalıştır → `npm test`/`make test` → hata varsa aynı promptta düzelt → `git commit` → çıktının özetini **bir sonraki promptun Bağlam**ına yapıştır (tüm sohbeti değil).

## Şablon
```
# Prompt <N> — <ad>
Bağlam: <dizin>; önceki adımda <ne yapıldı, hangi dosyalar>; durum: testler yeşil.
Hedef: <tek cümle>
Kısıtlar: Next.js App Router, TypeScript; yalnızca sentetik veri; arayüz Türkçe, sayılar tr-TR; yeni bağımlılık ekleme; <dokunulmayacak dosyalar>
Kabul ölçütü: `<komut>` → <beklenen sonuç>
Bitince: değişen dosyaların listesini ve çalıştırdığın komutların sonucunu yaz.
```

## Örnek (sentetik, "Gösterge Arama")
- **Prompt 1:** "Bu dizinde Next.js (TS, App Router) iskeleti hazır. `src/lib/data` altındaki `SeriDataSource` adaptörünü kullan; `node scripts/generate-sample-data.mjs 42` ile sentetik veri üret. Kabul: `cd apps/web && npm test` yeşil."
- **Prompt 2:** "`turkce-arama` skill'iyle `foldTr` tabanlı arama kutusu; sonuç sayısı `aria-live`. Kabul: 'cankiri' sorgusu 'Çankırı'yı bulur."
- **Prompt 3:** "Gösterge detay sayfası: birim, periyot, kaynak, `geçici/kesin` etiketi, `gizli` hücre 'gizli' yazar. Kabul: gizli hücre 0 görünmez."
- **Prompt 4:** "`tasarim-dokumani` ile `DESIGN.md` yaz, ekranları ona uydur."
- **Prompt 5:** "Boş/hata durumları, erişilebilirlik kontrolü, eksik testler. Kabul: `npm test` yeşil."
- **Prompt 6:** "README, örnek veri uyarısı, `/ship`."
Tam örnek: `examples/05-prompt-serisi/README.md`.

## Bitti kontrol listesi
- [ ] Her adımın kabul ölçütü komutla doğrulandı
- [ ] Her adım sonunda commit atıldı (`feat(web): ...`)
- [ ] Bağlam bir sonraki prompta özetle taşındı
- [ ] Veri yalnızca sentetik; günlükler repoya girmedi
- [ ] Son adımda `make lint` + `make test` + `kvkk-kontrol` temiz

## Sık hatalar
- Tek promptta tüm uygulamayı istemek.
- Test etmeden sonraki prompta geçmek (hata birikir).
- Önceki adımın çıktısını bağlama koymamak (model dosyaları tahmin eder).
- Gerçek veriye geçmek; adaptörü atlamak.
- Günlükleri (`run*.log`) commit etmek.

## İlgili
`prompt-yazma` · `veri-adaptoru` · `turkce-arama` · `tasarim-dokumani` · `nextjs-sayfa-bilesen` · `proje-baslat` · `examples/05-prompt-serisi/README.md`
