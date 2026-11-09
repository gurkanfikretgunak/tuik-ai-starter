/** packages/contracts/openapi.yaml ile uyumlu tipler (elle bakım). */
export interface HealthResponse { status: string }
export interface ApiErrorBody { error: { code: string; message: string } }
export type ObservationStatus = "geçici" | "kesin" | "revize" | "gizli" | "tahmini";
export interface Observation { period?: string; region?: string; value?: number | null; status?: ObservationStatus }
export interface Series { code?: string; name?: string; unit?: string; observations?: Observation[] }
