import { describe, expect, it } from "vitest";
import { getDataSource } from "./index";

describe("veri adaptörü", () => {
  it("örnek kaynak seri döndürür", async () => {
    const s = await getDataSource("sample").getByKod("ORNEK-ENDEKS");
    expect(s?.gozlemler.length).toBeGreaterThan(0);
  });
  it("gizli hücre null ve durum gizli", async () => {
    const s = await getDataSource("sample").getByKod("ORNEK-ENDEKS");
    const g = s!.gozlemler.filter((x) => x.durum === "gizli");
    expect(g.every((x) => x.deger === null)).toBe(true);
  });
  it("bilinmeyen kod null", async () => {
    expect(await getDataSource("sample").getByKod("YOK")).toBeNull();
  });
  it("tanımsız kaynak hata verir", () => {
    expect(() => getDataSource("gercek")).toThrow();
  });
});
