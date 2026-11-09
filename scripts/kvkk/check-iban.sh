#!/usr/bin/env bash
# TR IBAN taraması: mod-97 sağlaması geçen 26 karakterlik IBAN'lar bulgudur.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
ALLOWED="$(kvkk_allowed_values)"

out=$(
  kvkk_grep '(^|[^A-Za-z0-9])TR[0-9]{2}([ ]?[0-9A-Za-z]{4}){5}[ ]?[0-9A-Za-z]{2}([^A-Za-z0-9]|$)' -i |
  awk -v allowed="$ALLOWED" "$kvkk_mask_awk"'
    function mod97(s,   i, c, r, v) {
      r = 0
      for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        v = index("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", c) - 1
        if (v < 0) return -1
        r = (v < 10) ? (r * 10 + v) % 97 : (r * 100 + v) % 97
      }
      return r
    }
    { i = index($0, ":"); f = substr($0, 1, i - 1); r = substr($0, i + 1)
      j = index(r, ":"); ln = substr(r, 1, j - 1); m = substr(r, j + 1)
      m = toupper(m); gsub(/[^A-Z0-9]/, "", m)
      if (length(m) < 26) next
      m = substr(m, length(m) - 25)
      if (substr(m, 1, 2) != "TR" || index(allowed, "|" m "|")) next
      if (mod97(substr(m, 5) substr(m, 1, 4)) != 1) next
      printf "HATA [IBAN] %s:%s: geçerli TR IBAN (%s)\n", f, ln, mask(m) }' | sort -u
)
kvkk_finish "$out"
