#!/usr/bin/env bash
# KVKK kontrolcüleri için ortak işlevler. bash 3.2 (macOS) uyumludur.
# Bu dosya doğrudan çalıştırılmaz; her kontrolcü `source` eder.
#
# Ortam değişkenleri:
#   KVKK_ROOT   taranacak kök (varsayılan: repo kökü)
#   KVKK_MODE   all | staged   (staged: yalnızca `git add` ile hazırlanan dosyalar)
#   KVKK_FILES  NUL ayraçlı dosya listesi (run-all.sh üretir; yoksa lib üretir)
#
# Çıktı sözleşmesi: her bulgu tek satır, değer HER ZAMAN maskeli:
#   HATA|UYARI [KATEGORI] dosya:satır: açıklama
# Kontrolcü çıkış kodu: HATA varsa 1, yoksa 0 (UYARI tek başına 0).

KVKK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KVKK_ROOT="${KVKK_ROOT:-$(cd "$KVKK_DIR/../.." && pwd)}"
KVKK_MODE="${KVKK_MODE:-all}"
KVKK_ALLOWLIST="${KVKK_ALLOWLIST:-$KVKK_DIR/allowlist.txt}"

# Birleşik sır deseni (ERE). Tek kaynak: hem dosya hem geçmiş taraması kullanır.
KVKK_SECRET_RE='AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{50,}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{35}|eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|[0-9]{8,10}:[A-Za-z0-9_-]{35}|hooks\.slack\.com/services/[A-Za-z0-9/]+|discord(app)?\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+|[a-z][a-z0-9+.-]*://[^/[:space:]:@]+:[^/[:space:]:@<>$]{3,}@'

# Atama biçimindeki sırlar: anahtar adı + değer (yer tutucular ayrıca elenir).
KVKK_ASSIGN_RE='(api[_-]?key|secret|token|passw(or)?d|pwd|private[_-]?key|client[_-]?secret)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'<>${}[:space:]]{8,}["'"'"']'

# Yer tutucu işaretleri: bunları içeren değerler gerçek sayılmaz.
KVKK_PLACEHOLDER_RE='YER_TUTUCU|PLACEHOLDER|CHANGEME|changeme|your[_-]|example|ornek|sentetik|dummy|xxxx|[*][*][*][*]|[.][.][.]'

# Değeri maskele: ilk 2 + yıldız + son 2 (kısa değerler tamamen yıldız).
kvkk_mask_awk='
function mask(s,   n, i, m) {
  n = length(s)
  if (n <= 6) { m = ""; for (i = 0; i < n; i++) m = m "*"; return m }
  m = substr(s, 1, 2)
  for (i = 0; i < n - 4; i++) m = m "*"
  return m substr(s, n - 1, 2)
}'

# Allowlist: `path:<glob>` dosyayı atlar, `value:<tam değer>` bilinen sentetik değeri atlar.
kvkk_path_allowed() {
  [ -f "$KVKK_ALLOWLIST" ] || return 1
  local line pat
  while IFS= read -r line; do
    case "$line" in path:*) pat="${line#path:}"; case "$1" in $pat) return 0;; esac;; esac
  done < "$KVKK_ALLOWLIST"
  return 1
}

# Allowlist'teki değerleri awk için tek satırlık "|a|b|" dizgesine çevir.
kvkk_allowed_values() {
  [ -f "$KVKK_ALLOWLIST" ] || { printf '|'; return; }
  printf '|'
  grep '^value:' "$KVKK_ALLOWLIST" | sed 's/^value://' | tr '\n' '|'
}

# NUL ayraçlı, taranabilir dosya listesini stdout'a yaz.
kvkk_list_files() {
  cd "$KVKK_ROOT" || return 1
  local src f
  if git rev-parse --git-dir >/dev/null 2>&1; then
    if [ "$KVKK_MODE" = "staged" ]; then
      src=$(git diff --cached --name-only --diff-filter=ACMR -z | tr '\0' '\n')
    else
      src=$(git ls-files -co --exclude-standard -z | tr '\0' '\n')
    fi
  else
    src=$(find . -type f -not -path './.git/*' -not -path '*/node_modules/*' | sed 's|^\./||')
  fi
  printf '%s\n' "$src" | while IFS= read -r f; do
    [ -n "$f" ] && [ -f "$f" ] || continue
    case "$f" in
      */node_modules/*|*/.next/*|*/.venv/*|*/__pycache__/*|*.lock|*-lock.json|*/go.sum|go.sum) continue;;
      *.png|*.jpg|*.jpeg|*.gif|*.ico|*.webp|*.woff|*.woff2|*.ttf|*.pdf|*.zip|*.gz|*.pyc) continue;;
    esac
    kvkk_path_allowed "$f" && continue
    printf '%s\0' "$f"
  done
}

# Dosya listesini hazırla (run-all önceden KVKK_FILES verir).
kvkk_prepare() {
  if [ -z "${KVKK_FILES:-}" ]; then
    KVKK_FILES="$(mktemp -t kvkk.XXXXXX)"
    KVKK_OWN_FILES=1
    kvkk_list_files > "$KVKK_FILES"
    trap 'rm -f "$KVKK_FILES"' EXIT
  fi
  cd "$KVKK_ROOT" || exit 1
}

# Listedeki dosyalarda `grep -HnoEI` çalıştır. Boş listede sessizce biter.
# Kullanım: kvkk_grep <ERE> [ek grep bayrakları...]
kvkk_grep() {
  local re="$1"; shift
  [ -s "$KVKK_FILES" ] || return 0
  xargs -0 grep -HnoEI "$@" -e "$re" /dev/null < "$KVKK_FILES" 2>/dev/null || true
}

# Bulgu çıktısından çıkış kodunu üret: HATA varsa 1.
kvkk_finish() {
  local out="$1"
  [ -n "$out" ] && printf '%s\n' "$out"
  printf '%s\n' "$out" | grep -q '^HATA' && return 1
  return 0
}
