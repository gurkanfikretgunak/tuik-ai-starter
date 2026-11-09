---
description: Tüm yığını (API + web + hesaplama testi) yerelde başlat
---
Üç terminal öner:
```bash
cd services/api && go run ./cmd/api          # http://localhost:8080/health
cd apps/web && npm install && npm run dev    # http://localhost:3000
cd compute && python -m pytest -q            # hesaplama testleri
```
Web için `apps/web/.env.local` içinde `NEXT_PUBLIC_API_URL=http://localhost:8080` ayarla (örnek: `apps/web/.env.example`). Sır yazma.
