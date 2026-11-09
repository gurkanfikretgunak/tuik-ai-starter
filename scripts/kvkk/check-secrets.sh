#!/usr/bin/env bash
# Sır taraması: bulut/VCS anahtarları, özel anahtar başlıkları, JWT, bot/webhook,
# kimlik bilgili URL ve anahtar=değer atamaları. Değerin yalnızca baş 4 karakteri yazılır.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
ALLOWED="$(kvkk_allowed_values)"

report='
{ i = index($0, ":"); f = substr($0, 1, i - 1); r = substr($0, i + 1)
  j = index(r, ":"); ln = substr(r, 1, j - 1); m = substr(r, j + 1)
  if (index(allowed, "|" m "|")) next
  if (m ~ ph) next
  printf "HATA [SIR] %s:%s: %s… (%d karakter)\n", f, ln, substr(m, 1, 4), length(m) }'

out=$(
  {
    kvkk_grep "$KVKK_SECRET_RE" | awk -v allowed="$ALLOWED" -v ph="$KVKK_PLACEHOLDER_RE" "$report"
    kvkk_grep "$KVKK_ASSIGN_RE" -i | awk -v allowed="$ALLOWED" -v ph="$KVKK_PLACEHOLDER_RE" "$report"
  } | sort -u
)
kvkk_finish "$out"
