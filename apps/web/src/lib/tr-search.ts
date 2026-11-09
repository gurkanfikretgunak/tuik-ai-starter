const MAP: Record<string, string> = {
  İ: "i", I: "i", ı: "i", i: "i",
  Ş: "s", ş: "s", Ğ: "g", ğ: "g", Ü: "u", ü: "u", Ö: "o", ö: "o", Ç: "c", ç: "c",
};

/** Türkçe karakter duyarsız katlama. Karakter sayısı korunur (vurgulama indeksleri için). */
export function foldTr(s: string): string {
  let out = "";
  for (const ch of s) out += MAP[ch] ?? (ch.length === 1 ? ch.toLowerCase() : ch);
  return out;
}

export function matchesTr(text: string, query: string): boolean {
  const q = foldTr(query.trim());
  return q === "" || foldTr(text).includes(q);
}

export interface Segment { text: string; match: boolean }

/** Eşleşen kısmı işaretler; arayüz `match` olan parçayı <mark> ile gösterir. */
export function highlightTr(text: string, query: string): Segment[] {
  const q = foldTr(query.trim());
  if (!q) return [{ text, match: false }];
  const idx = foldTr(text).indexOf(q);
  if (idx < 0) return [{ text, match: false }];
  return [
    { text: text.slice(0, idx), match: false },
    { text: text.slice(idx, idx + q.length), match: true },
    { text: text.slice(idx + q.length), match: false },
  ].filter((p) => p.text !== "");
}
