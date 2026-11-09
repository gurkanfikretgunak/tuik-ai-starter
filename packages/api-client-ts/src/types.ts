/** packages/contracts/openapi.yaml ile uyumlu tipler (elle bakım). */
export interface HealthResponse { status: string }
export interface ApiErrorBody { error: { code: string; message: string } }
