# 8. Hook'lar, zafiyet takibi ve AI riskleri
**Seviye:** Zorunlu · **Süre:** 45 dk
1. `docs/security/ai-kullanim-riskleri.md` tablosunu oku; her riskin önlemini bul.
2. `make test-hooks` çalıştır; `prompt-guard`'ı sentetik bir T.C. kimlik no ile dene (örnek: test dosyasındaki sentetik numara), engellendiğini gör.
3. `make audit` ile tarama yap; bir bulguyu `docs/security/zafiyet-kayitlari.md` içine işle, sorumlu ve hedef tarih ata.
4. Yapay zekâdan bir paket önermesini iste; `command-guard` onay penceresinde paketi nasıl doğrularsın?
**Tartışma:** Hook neyi yakalamaz? (regex sınırları) — bu yüzden inceleme ve CI gerekir.
