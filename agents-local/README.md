# [FAZ 2] Yerel agent'lar — henüz aktif değil
Amaç: hassas veriyi buluta göndermeden, yerel modellerle görüntü işleme.
Planlanan: `vision/` (görüntü agent'ları), `runtime/` (Ollama/llama.cpp/vLLM yapılandırması), `evals/` (değerlendirme setleri).
Eklenecek: `.claude/skills/goruntu-isleme/`, `.claude/rules/vision-local.md`.
Faz 2 başlamadan önce: donanım (GPU), model seçimi ve veri sınıflandırması netleştirilmeli.

## Durum
Şu an dizinler boştur (`vision/`, `runtime/`, `evals/` yalnız `.gitkeep`). Çalıştırılacak komut yoktur. Mevcut `.claude/rules/vision-local.md` ilkeleri bağlayıcıdır.

## Neden yerel?
Bulut modeline gidecek her içerik "kamuya açıklanabilir mi?" sorusundan geçer (`.claude/rules/01-veri-gizliligi.md`). Cevap hayırsa iş yerel çözümle yapılır; bu dizin o çözümün yeridir.

## Faz 2 başlangıç kontrol listesi
- [ ] Donanım (GPU/bellek) belirlendi · [ ] Model ve lisans seçildi (doğrulanmadı: aday listesi yok)
- [ ] Veri sınıflandırması yapıldı (hangi görüntü hangi seviyede) · [ ] Çalışma ortamı ağdan yalıtım kararı
- [ ] Değerlendirme seti **sentetik/anonim** hazır · [ ] Risk değerlendirmesi: `/ai-risk`

## Planlanan dosya haritası
```
agents-local/
  vision/    görüntü işleme agent'ları
  runtime/   yerel model çalıştırma yapılandırması (kimlik bilgisi yazılmaz)
  evals/     sentetik değerlendirme setleri
```

## İlgili
`docs/adr/0001-monorepo-ve-yigin.md` · `docs/security/ai-kullanim-riskleri.md`
