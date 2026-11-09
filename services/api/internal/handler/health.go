package handler

import (
	"encoding/json"
	"net/http"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/application/getseries"
	"github.com/masterfabric/tuik-ai-starter/services/api/internal/domain"
	"github.com/masterfabric/tuik-ai-starter/services/api/internal/infrastructure/memory"
)

// Health reports service liveness.
func Health(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

// NewMux wires all routes.
func NewMux() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /health", Health)
	// Örnek bağlama: üretimde bellek içi depo yerine gerçek depo enjekte edilir.
	v := 100.0
	repo := memory.NewSeriesRepo(domain.Series{
		Code: "ORNEK-ENDEKS", Name: "Örnek Fiyat Endeksi (sentetik)", Unit: "endeks",
		Observations: []domain.Observation{{Period: "2024-01", Region: "A", Value: &v, Status: "kesin"}},
	})
	mux.HandleFunc("GET /series/{code}", GetSeries(getseries.New(repo)))
	return mux
}
