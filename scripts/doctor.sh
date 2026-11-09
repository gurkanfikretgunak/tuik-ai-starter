#!/usr/bin/env bash
# Ortam kontrolü: gerekli araçlar kurulu mu?
for t in git node npm go python3 make; do
  if command -v "$t" >/dev/null 2>&1; then echo "OK   $t"; else echo "EKSIK $t"; fi
done
