---
name: nextjs-sayfa-bilesen
description: Next.js App Router'da sayfa veya bileşen oluşturur (TypeScript, erişilebilir, Türkçe arayüz). Web arayüzü işlerinde kullan.
---
# Next.js sayfa/bileşen
1. API tipleri `packages/contracts`'tan gelir; yoksa önce sözleşmeyi ekle.
2. Sayfa: `apps/web/src/app/<yol>/page.tsx` (sunucu bileşeni). Etkileşim gerekiyorsa küçük bir `"use client"` bileşeni ayır.
3. Yükleniyor/hata/boş durumları ele al (`loading.tsx`, `error.tsx`).
4. Erişilebilirlik: başlık hiyerarşisi, etiketler, klavye, kontrast.
5. Sayı/tarih: `Intl` ile `tr-TR`.
6. Test: Vitest + Testing Library; en az render ve bir etkileşim.
