#!/usr/bin/env bash
# İletişim bilgisi: e-posta (UYARI) ve Türkiye cep telefonu (HATA).
# example/test/invalid alan adları ve noreply adresleri yer tutucu sayılır.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
ALLOWED="$(kvkk_allowed_values)"

split='
function parse(line,   i, r, j) {
  i = index(line, ":"); F = substr(line, 1, i - 1); r = substr(line, i + 1)
  j = index(r, ":"); LN = substr(r, 1, j - 1); M = substr(r, j + 1)
}'

out=$(
  {
    kvkk_grep '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' | awk -v allowed="$ALLOWED" "$kvkk_mask_awk $split"'
      { parse($0); lm = tolower(M)
        if (lm ~ /@(example\.(com|org|net)|[a-z0-9.-]*\.(test|invalid|localhost|example))$/) next
        if (lm ~ /(^|[^a-z0-9])(noreply|no-reply|users\.noreply)/) next
        if (index(allowed, "|" M "|")) next
        n = index(M, "@")
        printf "UYARI [E-POSTA] %s:%s: e-posta adresi (%s@%s)\n", F, LN, mask(substr(M, 1, n - 1)), substr(M, n + 1) }'
    kvkk_grep '(^|[^0-9])(\+90|0090|0)[ .-]?\(?5[0-9]{2}\)?[ .-]?[0-9]{3}[ .-]?[0-9]{2}[ .-]?[0-9]{2}([^0-9]|$)' | awk -v allowed="$ALLOWED" "$kvkk_mask_awk $split"'
      { parse($0); gsub(/[^0-9+]/, "", M)
        if (index(allowed, "|" M "|")) next
        printf "HATA [TELEFON] %s:%s: Türkiye cep telefonu biçimi (%s)\n", F, LN, mask(M) }'
  } | sort -u
)
kvkk_finish "$out"
