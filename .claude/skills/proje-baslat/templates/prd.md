# PRD: <proje adı>
Sürüm: 0.1 · Tarih: <YYYY-AA-GG> · Sahip: <ROL>

- **Problem:** <1-2 cümle; kim, neyi yapamıyor/yavaş yapıyor>
- **Kullanıcı:** <rol; ör. TÜİK istatistik uzmanı>
- **Veri (kamuya açık / hassas):** <sentetik | kamuya açık | hassas>. Hassassa: bulut modeline gitmez; `ai-risk-degerlendirme` sonucu: <Düşük/Orta/Yüksek>
- **Kapsam (yapılacak):**
  1. <özellik 1>
  2. <özellik 2>
- **Kapsam dışı:** <bilinçli olarak yapılmayanlar>
- **Başarı ölçütü:** <ölçülebilir; ör. `make test` yeşil, sayfa açılır, 3 senaryo geçer>
- **Şablon:** web-dashboard | go-service | py-calculation | fullstack-minimal
- **Sözleşme:** <yeni uç/şema var mı; `packages/contracts/openapi.yaml`>
- **Varsayımlar:** <sorulmadan varsayılanlar>
- **Riskler:** <veri, ifşa, doğruluk, bağımlılık>
- **Açık sorular:** <yalnızca kritik olanlar>

Not: yalnızca sentetik veri kullanılır; kurumsal eşik ve yöntemler koda gömülmez (parametre; kurum kararı).
