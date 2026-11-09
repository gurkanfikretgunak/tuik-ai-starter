---
name: proje-baslat
description: Fikirden çalışan iskelete kadar yeni proje başlatır. Yeni proje, PRD, şablon seçimi veya "nereden başlayayım" istendiğinde kullan.
---
# Proje başlatma
1. **Netleştir**: problem, kullanıcı, veri türü, başarı ölçütü (en fazla 4 soru).
2. **PRD**: `templates/prd.md` şablonuyla 1 sayfalık PRD.
3. **Şablon seç**: web-dashboard, go-service, py-calculation, fullstack-minimal.
4. **Sözleşme**: veri alışverişi varsa `packages/contracts` içinde taslak çıkar.
5. **Plan**: en fazla 7 adım; ilk adım 1 saatte bitecek kadar küçük olsun.
6. **Doğrula**: `make test` ile iskelet çalışıyor mu.
Hassas veri varsa önce `.claude/rules/01-veri-gizliligi.md` okunur.
