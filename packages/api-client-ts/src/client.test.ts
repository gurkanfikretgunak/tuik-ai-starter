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
});
