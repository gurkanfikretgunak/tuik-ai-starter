#!/usr/bin/env bash
# Tüm KVKK kontrolcülerini çalıştırır ve özet verir. Hiçbir değer açık yazılmaz (maskeli).
#
# Kullanım:
#   bash scripts/kvkk/run-all.sh [--staged] [--strict] [--history] [--root DIR] [--quiet]
#   --staged   yalnızca `git add` ile hazırlanan dosyalar (commit öncesi)
#   --strict   UYARI bulgularını da başarısızlık say
#   --history  git geçmişinde de sır ara
#   --root DIR başka bir kökü tara
# Çıkış kodu: HATA (veya --strict ile UYARI) varsa 1, yoksa 0.
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
STRICT=0; HISTORY=0; QUIET=0
export KVKK_MODE=all
while [ $# -gt 0 ]; do
  case "$1" in
    --staged) KVKK_MODE=staged;;
    --strict) STRICT=1;;
    --history) HISTORY=1;;
    --quiet) QUIET=1;;
    --root) shift; KVKK_ROOT="$(cd "$1" && pwd)"; export KVKK_ROOT;;
    -h|--help) sed -n '2,10p' "$0"; exit 0;;
    *) echo "bilinmeyen seçenek: $1" >&2; exit 2;;
  esac
  shift
done
export KVKK_MODE

. "$DIR/lib.sh"
KVKK_FILES="$(mktemp -t kvkk.XXXXXX)"; export KVKK_FILES
trap 'rm -f "$KVKK_FILES"' EXIT
kvkk_list_files > "$KVKK_FILES"
n=$(tr -cd '\0' < "$KVKK_FILES" | wc -c | tr -d ' ')
[ "$QUIET" = 1 ] || echo "KVKK kontrolü: $n dosya, mod=$KVKK_MODE, kök=$KVKK_ROOT"

checks="check-tckn check-iban check-contact check-secrets check-files check-microdata"
[ "$HISTORY" = 1 ] && checks="$checks check-history"
errors=0; warns=0
for c in $checks; do
  out=$(bash "$DIR/$c.sh" 2>&1); rc=$?
  e=$(printf '%s\n' "$out" | grep -c '^HATA'); w=$(printf '%s\n' "$out" | grep -c '^UYARI')
  errors=$((errors + e)); warns=$((warns + w))
  if [ -n "$out" ]; then printf '%s\n' "$out"
  elif [ "$QUIET" = 0 ]; then echo "OK    $c"; fi
  [ $rc -gt 1 ] && { echo "HATA  $c çalıştırılamadı (çıkış kodu $rc)"; errors=$((errors + 1)); }
done

echo "---"
echo "Özet: $errors HATA, $warns UYARI"
if [ "$errors" -gt 0 ] || { [ "$STRICT" = 1 ] && [ "$warns" -gt 0 ]; }; then
  echo "BAŞARISIZ: bulguları gider; gerçek veri/sır ise commit etme, anahtarı iptal et/döndür."
  echo "Sentetik/yanlış pozitif ise scripts/kvkk/allowlist.txt'e gerekçeyle ekle (değeri değil, dar kapsamlı kuralı)."
  exit 1
fi
echo "TEMİZ (otomatik kontroller yalnızca ilk savunma hattıdır; kvkk-kontrol skill'i ve insan incelemesi yerine geçmez)"
