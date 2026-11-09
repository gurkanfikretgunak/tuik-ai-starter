"""Hook'lar için ortak yardımcılar (yalnızca standart kütüphane)."""
import json
import re
import sys

# --- Hassas içerik kalıpları -------------------------------------------------
SECRET_PATTERNS = [
    ("AWS erişim anahtarı", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
    ("GitHub token", re.compile(r"\bgh[pousr]_[A-Za-z0-9]{36,}\b")),
    ("API anahtarı (sk-...)", re.compile(r"\bsk-[A-Za-z0-9_\-]{20,}\b")),
    ("Slack token", re.compile(r"\bxox[baprs]-[A-Za-z0-9\-]{10,}\b")),
    ("Özel anahtar", re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |)PRIVATE KEY-----")),
    ("Gömülü kimlik bilgisi", re.compile(
        r"(?i)\b(api[_-]?key|secret|token|passw(?:or)?d|parola)\b\s*[:=]\s*[\"'][^\"'\s]{8,}[\"']")),
]
PLACEHOLDER = re.compile(r"(?i)(example|ornek|örnek|xxx|changeme|your[_-]|<.+>|dummy|placeholder|\*{4,})")
IBAN_TR = re.compile(r"\bTR\d{2}(?:\s?\d{4}){5}\s?\d{2}\b")
ELEVEN = re.compile(r"(?<!\d)\d{11}(?!\d)")


def valid_tckn(s: str) -> bool:
    """T.C. kimlik numarası sağlama algoritması (yanlış pozitifleri azaltır)."""
    if len(s) != 11 or not s.isdigit() or s[0] == "0":
        return False
    d = [int(c) for c in s]
    d10 = ((sum(d[0:9:2]) * 7) - sum(d[1:8:2])) % 10
    d11 = sum(d[:10]) % 10
    return d[9] == d10 and d[10] == d11


def mask(s: str) -> str:
    return s if len(s) <= 4 else s[:2] + "*" * (len(s) - 4) + s[-2:]


def find_sensitive(text: str):
    """(tür, maskeli değer) listesi döndürür. Ham değeri asla geri vermez."""
    out = []
    for m in ELEVEN.finditer(text):
        if valid_tckn(m.group()):
            out.append(("T.C. kimlik no", mask(m.group())))
    for m in IBAN_TR.finditer(text):
        out.append(("IBAN", mask(m.group().replace(" ", ""))))
    for name, pat in SECRET_PATTERNS:
        for m in pat.finditer(text):
            if PLACEHOLDER.search(m.group()):
                continue
            out.append((name, mask(m.group())[:24]))
    return out


# --- G/Ç yardımcıları -------------------------------------------------------
def read_event() -> dict:
    try:
        return json.load(sys.stdin)
    except Exception:
        return {}


def emit(obj: dict) -> None:
    sys.stdout.write(json.dumps(obj, ensure_ascii=False))
    sys.stdout.flush()
