#!/usr/bin/env bash
# Basit hassas içerik taraması (ilk savunma hattı; yerine geçmez).
root="${1:-.}"
grep -rEn --exclude-dir={.git,node_modules,.next,.venv} \
 -e '\b[1-9][0-9]{10}\b' \
 -e '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
 -e 'TR[0-9]{2}( ?[0-9]{4}){5} ?[0-9]{2}' \
 -e '(api[_-]?key|secret|token|password)\s*[:=]\s*["'"'"'][^"'"'"']{8,}' \
 "$root" | sed -E 's/(.{40}).*/\1.../' || true
