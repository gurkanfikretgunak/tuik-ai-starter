package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/application/getseries"
	apperr "github.com/masterfabric/tuik-ai-starter/services/api/internal/shared/errors"
)

type errBody struct {
	Error struct {
		Code    string `json:"code"`
		Message string `json:"message"`
	} `json:"error"`
}

func writeErr(w http.ResponseWriter, status int, code, msg string) {
	var b errBody
	b.Error.Code, b.Error.Message = code, msg
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(b)
}

// GetSeries, GET /series/{code} uç noktasıdır. İş mantığı use case'dedir.
func GetSeries(uc *getseries.UseCase) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		resp, err := uc.Execute(r.Context(), getseries.Request{Code: r.PathValue("code")})
		switch {
		case err == nil:
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(resp.Series)
		case errors.Is(err, apperr.ErrInvalidArg):
			writeErr(w, http.StatusBadRequest, "invalid_argument", "geçersiz kod")
		case errors.Is(err, apperr.ErrNotFound):
			writeErr(w, http.StatusNotFound, "not_found", "seri bulunamadı")
		default:
			writeErr(w, http.StatusInternalServerError, "internal", "beklenmeyen hata")
		}
	}
}
