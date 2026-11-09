---
description: Yapay zekâ kullanım senaryosu için risk değerlendirmesi yap
argument-hint: <senaryo>
---
Senaryo: $ARGUMENTS

## Ne zaman
Yeni bir AI kullanımı, araç, MCP veya veri akışı eklemeden önce; "bu işte AI kullanabilir miyim?" sorusunda.

## Argüman sözdizimi ve varsayılanlar
`/ai-risk <senaryo cümlesi>` — örn. `/ai-risk anket açık uçlu yanıtlarını bulut modeliyle kodlamak`.

| Eksik girdi | Varsayım (sormadan) |
|---|---|
| Veri sınıfı | Belirtilmemişse "hassas olabilir" say; en temkinli sonucu ver |
| Araç | Bulut model (Claude Code) |
| Çıktı kullanımı | Dahili taslak (yayın değil) |
Yalnızca veri sınıfı kritik ve tahmin edilemiyorsa tek soru sor.

## Kullanılan skill/kural
`ai-risk-degerlendirme` (ana), `kvkk-kontrol` (veri varsa); kurallar: `.claude/rules/01-veri-gizliligi.md`, `13-ai-kullanim-riskleri.md`, `07-mcp-kullanimi.md`. Ayrıntı: `docs/security/ai-kullanim-riskleri.md`.

## Adımlar
1. Senaryoyu tek cümleye indir: ne yapılacak, hangi veri, hangi araç.
2. Veriyi sınıfla: kamuya açık / dahili / kişisel (KVKK) / gizli istatistiki. "Kamuya açıklanabilir mi?" sorusunu yanıtla.
3. `ai-risk-degerlendirme` skill'indeki risk listesini tara (veri sızıntısı, halüsinasyon, sahte paket, istem enjeksiyonu, aşırı yetki).
4. Her risk için bir önlem yaz (yerel çözüm, sentetik veri, doğrulama adımı, hook).
5. Veri bulut modele gidemiyorsa karar: "yerel çözüm (Faz 2) veya yapılmaz".
6. Onaylayanı belirt (veri sahibi / birim sorumlusu).

## Çıktı biçimi
```
Senaryo: ...
Karar: Uygun | Koşullu | Uygun değil
| Risk | Seviye | Önlem | Onaylayan |
|---|---|---|---|
Açık sorular / doğrulanmadı: ...
```

## Örnek
`/ai-risk il bazlı sentetik seriler için grafik kodu yazdırmak` → Karar: Uygun (sentetik veri); riskler: kütüphane adı uydurma → önlem: paketi doğrula.
`/ai-risk işletme düzeyi kayıtları modele yapıştırıp özetletmek` → Karar: Uygun değil; öneri: sentetik örnek üret veya yerel çözüm.

## Bitti kontrol listesi
- [ ] Veri sınıfı açıkça yazıldı.
- [ ] Her risk için önlem ve onaylayan var.
- [ ] Karar tek satırda net.
- [ ] Hassas içerik rapora kopyalanmadı.

## Sık hatalar
- Veri sınıfını varsaymadan "uygun" demek.
- Önlemi genel bırakmak ("dikkat edilmeli").
