import { describe, expect, it } from "vitest";
import { ApiError, createClient } from "./index";

const fake = (status: number, body: unknown) => async () => ({ status, json: async () => body });

describe("api client", () => {
  it("health döner", async () => {
    const c = createClient("http://x", fake(200, { status: "ok" }));
    expect(await c.health()).toEqual({ status: "ok" });
  });
  it("hata gövdesini ApiError'a çevirir", async () => {
    const c = createClient("http://x", fake(500, { error: { code: "boom", message: "patladı" } }));
    await expect(c.health()).rejects.toMatchObject({ status: 500, code: "boom" });
    await expect(c.health()).rejects.toBeInstanceOf(ApiError);
  });
  it("seriyi koduyla getirir ve kodu kaçışlar", async () => {
    let seen = "";
    const body = { code: "ORNEK_SERI_M", observations: [{ period: "2024-01", value: null, status: "gizli" }] };
    const c = createClient("http://x", async (path) => { seen = path; return { status: 200, json: async () => body }; });
    expect(await c.getSeries("A B")).toEqual(body);
    expect(seen).toBe("/series/A%20B");
  });
  it("seri bulunamayınca ApiError fırlatır", async () => {
    const c = createClient("http://x", fake(404, { error: { code: "not_found", message: "yok" } }));
    await expect(c.getSeries("YOK")).rejects.toMatchObject({ status: 404, code: "not_found" });
  });
});
