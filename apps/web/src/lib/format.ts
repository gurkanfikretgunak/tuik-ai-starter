/** Sayıyı tr-TR biçiminde yazar. */
export function formatNumber(value: number, digits = 1): string {
  return new Intl.NumberFormat("tr-TR", { maximumFractionDigits: digits, minimumFractionDigits: digits }).format(value);
}
