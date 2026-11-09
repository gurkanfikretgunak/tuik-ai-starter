package getseries

import (
	"context"
	"errors"
	"testing"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/domain"
	"github.com/masterfabric/tuik-ai-starter/services/api/internal/infrastructure/memory"
	apperr "github.com/masterfabric/tuik-ai-starter/services/api/internal/shared/errors"
)

func TestExecute(t *testing.T) {
	repo := memory.NewSeriesRepo(domain.Series{Code: "ORNEK", Name: "Örnek (sentetik)", Unit: "endeks"})
	uc := New(repo)

	cancelled, cancel := context.WithCancel(context.Background())
	cancel()

	tests := []struct {
		name    string
		ctx     context.Context
		code    string
		wantErr error
	}{
		{"başarılı", context.Background(), "ORNEK", nil},
		{"boş kod", context.Background(), "  ", apperr.ErrInvalidArg},
		{"bulunamadı", context.Background(), "YOK", apperr.ErrNotFound},
		{"iptal edilmiş bağlam", cancelled, "ORNEK", context.Canceled},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			_, err := uc.Execute(tc.ctx, Request{Code: tc.code})
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("hata = %v, beklenen %v", err, tc.wantErr)
			}
		})
	}
}
