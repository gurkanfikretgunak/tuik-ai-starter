import { describe, expect, it } from "vitest";
import { foldTr, highlightTr, matchesTr } from "./tr-search";

describe("tr-search", () => {
  it("İ/ı/I/i aynı katlanır", () => {
    expect(foldTr("İSTANBUL")).toBe("istanbul");
    expect(foldTr("ISPARTA")).toBe("isparta");
    expect(foldTr("ığdır")).toBe("igdir");
  });
  it("karakter sayısını korur", () => {
    expect(foldTr("ŞİŞLİ").length).toBe("ŞİŞLİ".length);
  });
  it("aksansız sorgu aksanlı metni bulur", () => {
    expect(matchesTr("Çankırı", "cankiri")).toBe(true);
    expect(matchesTr("Çankırı", "ankara")).toBe(false);
  });
  it("boş sorgu her şeyi eşler", () => {
    expect(matchesTr("x", "  ")).toBe(true);
  });
  it("vurgulama doğru dilimi işaretler", () => {
    const seg = highlightTr("Doğu Anadolu", "dogu");
    expect(seg[0]).toEqual({ text: "Doğu", match: true });
  });
});
