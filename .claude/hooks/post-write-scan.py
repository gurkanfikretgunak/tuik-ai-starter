#!/usr/bin/env python3
"""PostToolUse (Write|Edit|MultiEdit): yazılan dosyada sır/PII ve riskli kod kalıplarını tarar.

- Sır/PII bulunursa Claude'a "kaldır" geri bildirimi verir (engelleyici).
- Riskli kod kalıbı (OWASP odaklı hafif SAST) bulunursa düzeltme önerisi ekler.
- Bağımlılık dosyası değiştiyse zafiyet taraması hatırlatılır.
Bulgular .claude/logs/hook-bulgular.jsonl dosyasına (gitignore'lu) kaydedilir; `make audit` özetler.
"""
import json
import os
import re
import time
from _common import emit, find_sensitive, read_event

MANIFESTS = {"package.json", "package-lock.json", "go.mod", "go.sum", "pyproject.toml",
             "requirements.txt", "poetry.lock", "uv.lock"}

RISKS = {
    ".py": [
        (r"\beval\(|\bexec\(", "kod enjeksiyonu (CWE-95)", "eval/exec kullanma; ayrıştırıcı veya izinli işlem tablosu kullan"),
        (r"shell\s*=\s*True|os\.system\(", "komut enjeksiyonu (CWE-78)", "argüman listesiyle subprocess.run, shell=False"),
        (r"pickle\.loads?\(", "güvensiz seri durumdan çıkarma (CWE-502)", "JSON/Parquet kullan, güvenilmeyen pickle açma"),
        (r"verify\s*=\s*False", "TLS doğrulaması kapalı (CWE-295)", "doğrulamayı açık bırak"),
        (r"yaml\.load\((?!.*SafeLoader)", "güvensiz YAML (CWE-502)", "yaml.safe_load"),
        (r"execute\(\s*f[\"']|execute\([^)]*%\s", "SQL enjeksiyonu (CWE-89)", "parametreli sorgu"),
    ],
    ".js": [], ".ts": [], ".tsx": [], ".jsx": [],
    ".go": [
        (r"InsecureSkipVerify:\s*true", "TLS doğrulaması kapalı (CWE-295)", "doğrulamayı aç"),
        (r"exec\.Command\(\s*\"(?:sh|bash)\"", "komut enjeksiyonu (CWE-78)", "kabuk yerine doğrudan program + argümanlar"),
        (r"Sprintf\(\s*\"(?i:select|insert|update|delete)", "SQL enjeksiyonu (CWE-89)", "parametreli sorgu (?, $1)"),
        (r"\"(?:crypto/md5|crypto/sha1)\"", "zayıf özet algoritması (CWE-328)", "güvenlik amaçlıysa SHA-256+"),
    ],
}
JS_RISKS = [
    (r"\beval\(|new Function\(", "kod enjeksiyonu (CWE-95)", "eval kullanma"),
    (r"dangerouslySetInnerHTML|\.innerHTML\s*=|document\.write\(", "XSS (CWE-79)", "metin olarak yaz veya temizleyiciden geçir"),
    (r"child_process.*exec\(|\bexecSync\(", "komut enjeksiyonu (CWE-78)", "execFile + argüman listesi"),
    (r"rejectUnauthorized:\s*false", "TLS doğrulaması kapalı (CWE-295)", "doğrulamayı aç"),
]
for ext in (".js", ".ts", ".tsx", ".jsx"):
    RISKS[ext] = JS_RISKS


def log(entry: dict) -> None:
    try:
        d = os.path.join(os.environ.get("CLAUDE_PROJECT_DIR", "."), ".claude", "logs")
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "hook-bulgular.jsonl"), "a", encoding="utf-8") as f:
            f.write(json.dumps({"t": time.strftime("%Y-%m-%dT%H:%M:%S"), **entry}, ensure_ascii=False) + "\n")
    except OSError:
        pass


def main() -> None:
    ev = read_event()
    ti = ev.get("tool_input") or {}
    path = ti.get("file_path", "") or ""
    base = os.path.basename(path)
    ext = os.path.splitext(path)[1].lower()
    # Yazılan içerik: Write -> content, Edit -> new_string, MultiEdit -> edits[].new_string
    chunks = [ti.get("content", ""), ti.get("new_string", "")]
    chunks += [e.get("new_string", "") for e in ti.get("edits", []) if isinstance(e, dict)]
    text = "\n".join(c for c in chunks if c)
    if not text and os.path.isfile(path):
        try:
            text = open(path, encoding="utf-8", errors="ignore").read()
        except OSError:
            text = ""

    notes, block = [], []
    sens = find_sensitive(text)
    if sens and not path.endswith((".example", ".md")) and "/tests/" not in path:
        block.append("Hassas içerik: " + ", ".join(f"{k} ({v})" for k, v in sens)
                     + " — dosyadan kaldır; sır için ortam değişkeni, veri için sentetik örnek kullan.")
        log({"tur": "hassas", "dosya": path, "bulgu": [k for k, _ in sens]})

    for pat, ad, cozum in RISKS.get(ext, []):
        for i, line in enumerate(text.splitlines(), 1):
            if re.search(pat, line):
                notes.append(f"{base}: olası zafiyet — {ad}. Öneri: {cozum}. (satır ~{i})")
                log({"tur": "kod-riski", "dosya": path, "kural": ad})
                break

    if base in MANIFESTS:
        notes.append(f"{base} değişti: yeni/güncellenen bağımlılıkları doğrula ve `make audit` ile zafiyet taramasını çalıştır; "
                     "bulguları docs/security/zafiyet-kayitlari.md içinde takip et.")
        log({"tur": "bagimlilik-degisti", "dosya": path})

    if block:
        emit({"decision": "block", "reason": " ".join(block + notes)})
    elif notes:
        emit({"hookSpecificOutput": {"hookEventName": "PostToolUse",
                                     "additionalContext": "[GÜVENLİK UYARISI] " + " | ".join(notes)}})


if __name__ == "__main__":
    main()
