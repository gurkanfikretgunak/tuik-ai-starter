#!/usr/bin/env bash
# Hassas dosyalara erişimi engeller. Girdi: stdin'de JSON. Çıkış kodu 2 = engelle.
input="$(cat)"
if echo "$input" | grep -Eq '(\.env(\.|"|$)|data/raw/|data/private/|\.pem|id_rsa|\.sav"|\.dta")'; then
  echo "ENGELLENDI: Hassas dosya/veri yoluna erişim. Bkz. .claude/rules/01-veri-gizliligi.md" >&2
  exit 2
fi
exit 0
