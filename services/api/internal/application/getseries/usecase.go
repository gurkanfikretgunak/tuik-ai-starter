// Package getseries, "seriyi koduyla getir" use case'idir.
package getseries

import (
	"context"
	"fmt"
	"strings"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/domain"
	apperr "github.com/masterfabric/tuik-ai-starter/services/api/internal/shared/errors"
)

type Request struct{ Code string }
type Response struct{ Series domain.Series }

type UseCase struct{ repo domain.SeriesRepository }

func New(repo domain.SeriesRepository) *UseCase { return &UseCase{repo: repo} }

// Execute, kod doğrulaması yapar ve seriyi döndürür.
func (u *UseCase) Execute(ctx context.Context, req Request) (Response, error) {
	if err := ctx.Err(); err != nil {
		return Response{}, err
	}
	code := strings.TrimSpace(req.Code)
	if code == "" || len(code) > 64 {
		return Response{}, fmt.Errorf("kod: %w", apperr.ErrInvalidArg)
	}
	s, err := u.repo.FindByCode(code)
	if err != nil {
		return Response{}, fmt.Errorf("seri %q: %w", code, err)
	}
	return Response{Series: *s}, nil
}
