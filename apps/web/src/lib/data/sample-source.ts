import type { Seri, SeriDataSource } from "./types";

/** SENTETİK örnek veri. Gerçek veri değildir. */
const SERILER: Seri[] = [
  {
    kod: "ORNEK-ENDEKS",
    ad: "Örnek Fiyat Endeksi (sentetik)",
    birim: "Endeks (2024=100)",
    periyot: "aylık",
    kaynak: "Sentetik örnek veri",
    gozlemler: [
      { donem: "2024-01", bolge: "A", deger: 100.0, durum: "kesin" },
      { donem: "2024-02", bolge: "A", deger: 102.5, durum: "kesin" },
      { donem: "2024-03", bolge: "A", deger: 101.2, durum: "geçici" },
      { donem: "2024-03", bolge: "B", deger: null, durum: "gizli" },
    ],
  },
];

export const sampleSource: SeriDataSource = {
  async getAll() {
    return SERILER;
  },
  async getByKod(kod) {
    return SERILER.find((s) => s.kod === kod) ?? null;
  },
};
