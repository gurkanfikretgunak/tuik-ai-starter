// Package errors, katmanlar arasında paylaşılan sentinel hataları tanımlar.
package errors

import stderrors "errors"

var (
	ErrNotFound   = stderrors.New("kayıt bulunamadı")
	ErrInvalidArg = stderrors.New("geçersiz argüman")
	ErrSuppressed = stderrors.New("değer gizlilik nedeniyle bastırıldı")
)
