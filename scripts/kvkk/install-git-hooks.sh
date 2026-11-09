#!/usr/bin/env bash
# Commit öncesi KVKK kontrolünü yerel git hook'u olarak kurar (yalnızca bu klonda geçerlidir).
# Mevcut farklı bir pre-commit varsa üzerine yazmaz. Kaldırmak için: rm .git/hooks/pre-commit
# Kurulu hook'u gerekçesiz atlama; bulgu varsa önce gider.
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HOOK="$ROOT/.git/hooks/pre-commit"
BODY='#!/usr/bin/env bash
# tuik-ai-starter: commit öncesi KVKK kontrolü (scripts/kvkk/install-git-hooks.sh ile kuruldu)
exec bash "$(git rev-parse --show-toplevel)/scripts/kvkk/run-all.sh" --staged --quiet'
[ -d "$ROOT/.git" ] || { echo "git deposu bulunamadı" >&2; exit 1; }
if [ -f "$HOOK" ] && ! grep -q 'scripts/kvkk/run-all.sh' "$HOOK"; then
  echo "Mevcut pre-commit hook'u var ve bize ait değil; dokunulmadı: $HOOK" >&2; exit 1
fi
mkdir -p "$ROOT/.git/hooks"
printf '%s\n' "$BODY" > "$HOOK"; chmod +x "$HOOK"
echo "Kuruldu: $HOOK"
