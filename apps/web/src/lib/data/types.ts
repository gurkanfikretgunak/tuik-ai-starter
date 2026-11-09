export type Durum = "geçici" | "kesin" | "revize" | "gizli" | "tahmini";

export interface Gozlem {
  donem: string; // ISO: 2026-03
  bolge: string;
  deger: number | null; // gizli hücrede null
  durum: Durum;
}

export interface Seri {
  kod: string;
  ad: string;
  birim: string;
  periyot: "aylık" | "çeyreklik" | "yıllık";
  kaynak: string;
  gozlemler: Gozlem[];
}

/** Gerçek kaynak (API, dosya, veritabanı) bu arayüzü uygular; bileşenler yalnızca bunu bilir. */
export interface SeriDataSource {
  getAll(): Promise<Seri[]>;
  getByKod(kod: string): Promise<Seri | null>;
}
