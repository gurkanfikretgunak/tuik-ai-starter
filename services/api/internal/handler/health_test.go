package handler

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealth(t *testing.T) {
	tests := []struct {
		name   string
		method string
		path   string
		want   int
	}{
		{"ok", http.MethodGet, "/health", http.StatusOK},
		{"wrong method", http.MethodPost, "/health", http.StatusMethodNotAllowed},
		{"unknown path", http.MethodGet, "/nope", http.StatusNotFound},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			rec := httptest.NewRecorder()
			NewMux().ServeHTTP(rec, httptest.NewRequest(tc.method, tc.path, nil))
			if rec.Code != tc.want {
				t.Fatalf("got %d, want %d", rec.Code, tc.want)
			}
		})
	}
}

func TestSeriesEndpoint(t *testing.T) {
	tests := []struct {
		name string
		path string
		want int
	}{
		{"var", "/series/ORNEK-ENDEKS", http.StatusOK},
		{"yok", "/series/YOK", http.StatusNotFound},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			rec := httptest.NewRecorder()
			NewMux().ServeHTTP(rec, httptest.NewRequest(http.MethodGet, tc.path, nil))
			if rec.Code != tc.want {
				t.Fatalf("got %d, want %d", rec.Code, tc.want)
			}
		})
	}
}
