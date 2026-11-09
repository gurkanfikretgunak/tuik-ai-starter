import { sampleSource } from "./sample-source";
import type { SeriDataSource } from "./types";

/**
 * Aktif veri kaynağı TEK yerden seçilir. Gerçek kaynağa geçmek için burada yeni bir
 * `SeriDataSource` uygulaması bağlanır; bileşenler değişmez.
 */
export function getDataSource(kind = process.env.DATA_SOURCE ?? "sample"): SeriDataSource {
  if (kind === "sample") return sampleSource;
  throw new Error(`Tanımsız veri kaynağı: ${kind}`);
}

export * from "./types";
