// Deterministik (seed'li) SENTETİK veri üretir: data/sample/sentetik-seri.json
// Çalıştır: node scripts/generate-sample-data.mjs [seed]
import { writeFileSync } from "node:fs";

function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const seed = Number(process.argv[2] ?? 42);
const rnd = mulberry32(seed);
const bolgeler = ["A", "B", "C", "D", "E"];
const gozlemler = [];
for (const b of bolgeler) {
  let level = 100;
  for (let m = 1; m <= 12; m++) {
    level *= 1 + (rnd() - 0.45) / 50;
    const birim = Math.floor(rnd() * 12) + 1; // hücredeki birim sayısı (ifşa kontrolü denemesi için)
    gozlemler.push({
      donem: `2024-${String(m).padStart(2, "0")}`,
      bolge: b,
      deger: Math.round(level * 10) / 10,
      birim_sayisi: birim,
      durum: m > 10 ? "geçici" : "kesin",
    });
  }
}
const out = { sentetik: true, seed, uretim: "scripts/generate-sample-data.mjs", gozlemler };
writeFileSync(new URL("../data/sample/sentetik-seri.json", import.meta.url), JSON.stringify(out, null, 2));
console.log(`yazıldı: ${gozlemler.length} gözlem (seed=${seed})`);
