import { describe, expect, it } from "vitest";
import { formatNumber } from "./format";

describe("formatNumber", () => {
  it("tr-TR ondalık ayracı kullanır", () => {
    expect(formatNumber(1234.5)).toMatch(/1\.234,5/);
  });
});
