#!/usr/bin/env bash
# Git geçmişi taraması: silinmiş olsa bile eski commit'lerde kalmış sırları arar.
# Yalnızca git deposunda çalışır. Bulgu varsa anahtarı İPTAL ET/DÖNDÜR; geçmişi yeniden
# yazmak (force push) ayrı ve açık onay gerektirir — bu betik hiçbir şeyi değiştirmez.
. "$(dirname "$0")/lib.sh"
cd "$KVKK_ROOT" || exit 1
git rev-parse --git-dir >/dev/null 2>&1 || { echo "git deposu değil; geçmiş taraması atlandı"; exit 0; }
ALLOWED="$(kvkk_allowed_values)"

out=$(
  revs=$(git rev-list --all 2>/dev/null)
  [ -z "$revs" ] && exit 0
  # shellcheck disable=SC2086
  git grep -nEI -e "$KVKK_SECRET_RE" $revs -- . ':(exclude)scripts/kvkk' 2>/dev/null |
  awk -v allowed="$ALLOWED" -v ph="$KVKK_PLACEHOLDER_RE" '
    { split($0, p, ":"); rev = substr(p[1], 1, 8); f = p[2]; ln = p[3]
      line = $0; sub(/^[^:]*:[^:]*:[0-9]+:/, "", line)
      if (line ~ ph) next
      printf "HATA [GECMIS-SIR] %s %s:%s: geçmişte sır benzeri içerik (değer yazılmadı)\n", rev, f, ln }' | sort -u
)
kvkk_finish "$out"
