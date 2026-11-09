import type { ApiErrorBody, HealthResponse, Series } from "./types";
export * from "./types";

export type Transport = (path: string, init?: { method?: string; body?: unknown }) => Promise<{ status: number; json(): Promise<unknown> }>;

export class ApiError extends Error {
  constructor(public status: number, public code: string, message: string) { super(message); }
}

/** Sözleşmede olup istemcide henüz bulunmayanlar (görünür borç). */
export const CLIENT_GAPS: string[] = [];

export function createClient(baseUrl: string, transport?: Transport) {
  const t: Transport = transport ?? ((path, init) =>
    fetch(baseUrl + path, { method: init?.method, body: init?.body ? JSON.stringify(init.body) : undefined,
      headers: { "Content-Type": "application/json" } }));
  async function call<T>(path: string, init?: { method?: string; body?: unknown }): Promise<T> {
    const res = await t(path, init);
    const data = await res.json();
    if (res.status >= 400) {
      const e = (data as ApiErrorBody).error ?? { code: "unknown", message: "bilinmeyen hata" };
      throw new ApiError(res.status, e.code, e.message);
    }
    return data as T;
  }
  return {
    health: () => call<HealthResponse>("/health"),
    /** GET /series/{code}; gizli hücrede value null ve status "gizli" gelir. */
    getSeries: (code: string) => call<Series>(`/series/${encodeURIComponent(code)}`),
  };
}
