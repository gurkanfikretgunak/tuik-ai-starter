// Package domain, hiçbir dış katmana bağımlı olmayan iş varlıklarını içerir.
package domain

// Observation, bir seriye ait tek gözlemdir. Gizli hücrede Value nil'dir.
type Observation struct {
	Period string   `json:"period"`
	Region string   `json:"region"`
	Value  *float64 `json:"value"`
	Status string   `json:"status"` // geçici | kesin | revize | gizli | tahmini
}

// Series, bir istatistik göstergesinin zaman serisidir.
type Series struct {
	Code         string        `json:"code"`
	Name         string        `json:"name"`
	Unit         string        `json:"unit"`
	Observations []Observation `json:"observations"`
}

// SeriesRepository uygulaması infrastructure katmanındadır.
type SeriesRepository interface {
	FindByCode(code string) (*Series, error)
}
