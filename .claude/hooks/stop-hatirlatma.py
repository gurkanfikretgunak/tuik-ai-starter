#!/usr/bin/env python3
"""Stop: kod değişmişse kullanıcıya doğrulama hatırlatması gösterir (engellemez)."""
import os
import subprocess
from _common import emit, read_event

ev = read_event()
if ev.get("stop_hook_active"):
    raise SystemExit(0)
root = os.environ.get("CLAUDE_PROJECT_DIR", ".")
try:
    out = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True,
                         cwd=root, timeout=10).stdout
except Exception:
    raise SystemExit(0)
code = [l for l in out.splitlines() if l[3:].endswith((".go", ".py", ".ts", ".tsx", ".js"))]
if code:
    emit({"systemMessage": (
        f"{len(code)} kod dosyası değişti. Yapay zekâ çıktısını birleştirmeden önce: "
        "`make test` · `make audit` · `/review` · hassas veri/sır kontrolü (kvkk-kontrol).")})
