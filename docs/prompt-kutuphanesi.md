# Prompt kütüphanesi

Az prompt ile iş bitirmek için kopyala-yapıştır şablonlar. `<...>` içini doldur; geri kalanı olduğu gibi bırak. Gerçek veri, kişisel veri ve anahtar YAPIŞTIRMA; yalnızca sentetik değer.

## İyi prompt formülü
`Hedef` + `Dosya/yol` + `Kısıt` + `Bitti tanımı`. Varsayılanı söylersen model soru sormaz. Tek prompt, tek amaç.

## Şablonlar

### 1. Yeni endpoint
```
/new-endpoint GET /series/{code}/latest Bir serinin son gözlemini döndür.
Varsayılanlar: sözleşme önce (packages/contracts/openapi.yaml), mevcut getseries kalıbı, bellek içi depo, 404 için hata kodu.
Bitti: make test yeşil, CHANGELOG api: satırı.
```

### 2. Yeni sayfa
```
/new-page /seriler sayfası: getDataSource() ile seri listesi tablosu, Türkçe başlıklar, gizli hücre "gizli" yazsın.
Varsayılan: sentetik kaynak, sunucu bileşeni, bir test, package.json sürümü MINOR.
```

### 3. Yeni hesaplama
```
/new-calc compute/src/tuik_calc içine <ad>: <ne hesaplıyor>. Girdi: <liste>. Hata: ValueError.
Varsayılan: tip ipuçları, docstring örneği, pytest (normal, sınır, hata). Eşik değerleri parametre.
```

### 4. İfşa kontrolü
```
/ifsa-kontrol <tablo>. disclosure.py fonksiyonlarını kullan. Eşikler parametre: min_count=<N>, top_n=<K>, max_share=<P> (kurum kararı, yer tutucu).
Çıktı: bastırılan hücre listesi ve test.
```

### 5. Hata düzeltme
```
Hata: <belirti>, dosya: <yol>. Önce hatayı yeniden üreten testi yaz, sonra düzelt. Başka dosyaya dokunma.
```

### 6. Test yazma
```
<yol> için eksik testleri yaz: bir başarılı, bir hata yolu. Gerçek veri kullanma. Kodu değiştirme.
```

### 7. Sözleşme değişimi
```
openapi.yaml'a <alan> ekle (isteğe bağlı). Sonra /regenerate-client. make test çalıştır.
```

### 8. İnceleme ve bitirme
```
/review   (sonra)   /ship
```

### 9. Zafiyet
```
/audit. Yeni bulguları zafiyet-kayitlari.md içine sorumlu ve hedef tarihle işle. Düzeltme önerme, sadece kaydet.
```

### 10. GSBPM planı
```
/new-surec <gösterge adı>: aylık, sentetik veri. Her aşama için çıktı ve kontrol tablosu ver. Kod yazma.
```

## Kötü → iyi
| Kötü | Neden | İyi |
|---|---|---|
| "Bir API yap" | Hedef, yol, sözleşme yok | "GET /series/{code}/latest, openapi önce, test ile" |
| "Şu veriyi analiz et" (gerçek veri yapıştırılmış) | Veri gizliliği ihlali | "data/sample/ornek_seri.csv üzerinde ortalama hesapla" |
| "Düzelt" | Neresi? | "compute/src/tuik_calc/weights.py: boş girdide ValueError bekleniyor, test yaz, düzelt" |
| "Herşeyi iyileştir" | Kapsam sınırsız | "Yalnızca format.ts: binlik ayracı Türkçe olsun, test ekle" |
| "Eşiği 3 yap" (koda gömme) | Kurum kararı | "min_count parametre olsun, varsayılan yok" |
| "Test sonra" | Bitmiş sayılmaz | "Önce test, sonra kod" |
| "Paketi X ekle" (varlığı belirsiz) | Uydurma paket riski | "X gerçekten var mı, lisansı? Doğrulayamazsan ekleme" |

## Küçük adım kuralı
Büyük işi bölün: 1) sözleşme, 2) kod, 3) test, 4) CHANGELOG. Her adım ayrı prompt; her adımdan sonra `make test`.

## Sık hatalar
- Hedef belirtmeden dosya listesi yapıştırmak.
- Tek promptta birden çok katmanı (API + web + hesaplama) istemek.
- Modelin sonucunu çalıştırmadan doğru kabul etmek.

## İlgili
`docs/egitim/02-iyi-prompt-ve-brief.md`, `.claude/skills/prompt-yazma/SKILL.md`, `.claude/skills/prompt-serisi/SKILL.md`, `docs/baglam/02-tarifler.md`.
