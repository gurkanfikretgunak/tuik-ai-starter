#!/usr/bin/env bash
# T.C. kimlik no (sağlaması geçerli 11 hane) ve bağlamlı kimlik/vergi no taraması.
# Sağlama (checksum) kullanıldığı için rastgele 11 haneli sayılar bulgu üretmez.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
ALLOWED="$(kvkk_allowed_values)"

split='
function parse(line,   i, r, j) {
  i = index(line, ":"); F = substr(line, 1, i - 1); r = substr(line, i + 1)
  j = index(r, ":"); LN = substr(r, 1, j - 1); M = substr(r, j + 1)
}
function valid(m,   i, d, odd, even, s) {
  if (length(m) != 11) return 0
  for (i = 1; i <= 11; i++) d[i] = substr(m, i, 1) + 0
  if (d[1] == 0) return 0
  odd = d[1] + d[3] + d[5] + d[7] + d[9]; even = d[2] + d[4] + d[6] + d[8]
  if (((odd * 7 - even) % 10 + 10) % 10 != d[10]) return 0
  s = 0; for (i = 1; i <= 10; i++) s += d[i]
  return (s % 10 == d[11])
}'

out=$(
  {
    kvkk_grep '(^|[^0-9A-Za-z_])[0-9]{11}([^0-9A-Za-z_]|$)' | awk -v allowed="$ALLOWED" "$kvkk_mask_awk $split"'
      { parse($0); gsub(/[^0-9]/, "", M)
        if (!valid(M) || index(allowed, "|" M "|")) next
        printf "HATA [TCKN] %s:%s: geçerli T.C. kimlik no biçimi (%s)\n", F, LN, mask(M) }'
    kvkk_grep '(tc[ _-]?kimlik|tckn|kimlik[ _-]?no)[^0-9]{0,20}[0-9]{11}([^0-9]|$)' -i | awk -v allowed="$ALLOWED" "$kvkk_mask_awk $split"'
      { parse($0); gsub(/[^0-9]/, "", M); M = substr(M, length(M) - 10)
        if (valid(M) || index(allowed, "|" M "|")) next
        printf "UYARI [TCKN-BAĞLAM] %s:%s: kimlik anahtar sözcüğünün yanında 11 haneli sayı (%s)\n", F, LN, mask(M) }'
    kvkk_grep '(vergi[ _-]?(no|numaras)|vkn)[^0-9]{0,20}[0-9]{10}([^0-9]|$)' -i | awk -v allowed="$ALLOWED" "$kvkk_mask_awk $split"'
      { parse($0); gsub(/[^0-9]/, "", M); M = substr(M, length(M) - 9)
        if (index(allowed, "|" M "|")) next
        printf "UYARI [VKN-BAĞLAM] %s:%s: vergi no anahtar sözcüğünün yanında 10 haneli sayı (%s)\n", F, LN, mask(M) }'
  } | sort -u
)
kvkk_finish "$out"
