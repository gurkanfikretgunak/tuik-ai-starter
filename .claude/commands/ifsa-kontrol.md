---
description: Yayımlanacak tablo/API çıktısında ifşa kontrolü yap
argument-hint: <tablo veya uç nokta>
---
Hedef: $ARGUMENTS

## Ne zaman
Tablo, grafik veya API ucu yayımlanmadan önce; her seferinde.

## Argüman sözdizimi ve varsayılanlar
`/ifsa-kontrol <dosya | tablo adı | METHOD /yol>` — örn. `/ifsa-kontrol GET /v1/seriler`.

| Eksik girdi | Varsayım |
|---|---|
| Eşikler (min. birim, baskınlık) | **Uydurma.** Yapılandırmadan/kullanıcıdan al; yoksa parametre olarak bırak (kurum kararı) |
| Kırılımlar | Çıktıdaki tüm boyutlar ve filtre kombinasyonları |
| Veri | Yalnızca `data/sample/` sentetik verisi |

## Kullanılan skill/kural
`ifsa-kontrolu` (ana), `kvkk-kontrol`; kural: `.claude/rules/10-ifsa-kontrolu.md`. Test örnekleri: `compute/tests/test_disclosure.py`.

## Adımlar
1. Hedefi bul (tablo üretimi, handler veya dosya); boyut ve kırılımları listele.
2. Eşik parametrelerini belirle (yoksa kullanıcıya tek soru: "eşik değerleri nedir?").
3. Küçük hücre (birim sayısı < eşik) kontrolünü uygula.
4. Baskınlık kontrolü (en büyük 1–2 birimin payı).
5. İkincil bastırma: toplamlardan geri hesaplanabilen hücreleri bastır.
6. Filtre/kırılım kombinasyonlarıyla fark alma saldırısını kontrol et.
7. Bastırılan hücre sayısını ve gerekçeyi raporla; testi ekle/çalıştır (`make test`).

## Çıktı biçimi
```
Hedef: ... | Eşikler: <parametre>
Birincil bastırma: N | Baskınlık: N | İkincil: N
Riskli kombinasyonlar: ...
Karar: Yayımlanabilir | Bastırma sonrası yayımlanabilir | Yayımlanamaz
```

## Örnek
`/ifsa-kontrol sentetik-seri il x faaliyet tablosu` → 3 hücre birincil, 2 ikincil bastırma; karar: bastırma sonrası yayımlanabilir.

## Bitti kontrol listesi
- [ ] Eşikler yapılandırmadan geldi, koda gömülmedi.
- [ ] Birincil + ikincil bastırma yapıldı.
- [ ] Filtre kombinasyonları denendi.
- [ ] Bastırılan sayı raporlandı, test geçti.

## Sık hatalar
- Yalnızca tek tabloya bakıp toplam farkından geri hesabı atlamak.
- Eşik uydurmak.
- Bastırmayı gizlemek yerine "X/D" gibi işaretlemeyi unutmak (biçim: kurum kararı).
