// Package memory, test ve örnek amaçlı bellek içi (SENTETİK veri) depo sağlar.
package memory

import (
	"github.com/masterfabric/tuik-ai-starter/services/api/internal/domain"
	apperr "github.com/masterfabric/tuik-ai-starter/services/api/internal/shared/errors"
)

type SeriesRepo struct{ data map[string]domain.Series }

func NewSeriesRepo(items ...domain.Series) *SeriesRepo {
	m := make(map[string]domain.Series, len(items))
	for _, s := range items {
		m[s.Code] = s
	}
	return &SeriesRepo{data: m}
}

func (r *SeriesRepo) FindByCode(code string) (*domain.Series, error) {
	s, ok := r.data[code]
	if !ok {
		return nil, apperr.ErrNotFound
	}
	return &s, nil
}
