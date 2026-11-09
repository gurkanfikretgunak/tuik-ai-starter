#!/usr/bin/env python3
"""PreToolUse (Bash): tehlikeli komutları reddeder, bağımlılık eklemelerinde onay ister.

Yapay zekâ çoğu zaman var olmayan/yanlış yazılmış paket adları önerir (paket yanıltması,
"slopsquatting"). Saldırganlar bu adları önceden kaydeder. Bu yüzden her yeni bağımlılık
insan onayından geçer.
"""
import re
from _common import emit, read_event

DANGEROUS = [
    (re.compile(r"(curl|wget)[^|;]*\|\s*(sudo\s+)?(ba|z)?sh\b"), "ağdan indirip doğrudan kabukta çalıştırma"),
    (re.compile(r"\brm\s+-[a-zA-Z]*r[a-zA-Z]*f?[a-zA-Z]*\s+(/|~|\*|\$HOME)(\s|$)"), "kök/ev dizinini silme"),
    (re.compile(r"\bgit\s+push\b[^\n]*(--force\b|\s-f\b)"), "zorla push (geçmişi bozar)"),
    (re.compile(r"--no-verify\b"), "commit/push denetimlerini atlama"),
    (re.compile(r"\bchmod\s+(-R\s+)?777\b"), "herkese yazma izni"),
    (re.compile(r"\bsudo\b"), "yönetici yetkisiyle komut"),
    (re.compile(r"\b(DROP|TRUNCATE)\s+(TABLE|DATABASE)\b", re.I), "yıkıcı veritabanı komutu (bkz. docs/runbooks/paylasimli-ortam-veri-kurallari.md)"),
    (re.compile(r"\bcat\s+[^\n|;]*\.env\b"), ".env içeriğini yazdırma"),
]

INSTALL = [
    (re.compile(r"\b(?:npm|pnpm|yarn)\s+(?:install|i|add)\s+(.+)"), "npm"),
    (re.compile(r"\bpip3?\s+install\s+(.+)"), "PyPI"),
    (re.compile(r"\bgo\s+(?:get|install)\s+(.+)"), "Go modülü"),
]


def packages(arg: str):
    toks = re.split(r"\s+", arg.strip())
    out, skip = [], False
    for t in toks:
        if skip:
            skip = False
            continue
        if t in ("-r", "--requirement", "-e", "--editable", "-c"):
            skip = True
            continue
        if t.startswith("-") or t in ("&&", ";", "|") or t.startswith(("&", ";", "|")):
            if t in ("&&", ";", "|"):
                break
            continue
        out.append(t)
    return out


def main() -> None:
    ev = read_event()
    cmd = (ev.get("tool_input") or {}).get("command", "") or ""
    for pat, why in DANGEROUS:
        if pat.search(cmd):
            emit({"hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": f"Komut reddedildi: {why}. Gerekliyse kullanıcıdan açık onay alın.",
            }})
            return
    for pat, eco in INSTALL:
        m = pat.search(cmd)
        if m:
            pk = packages(m.group(1))
            if not pk:
                continue
            emit({"hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "ask",
                "permissionDecisionReason": (
                    f"YENİ BAĞIMLILIK ({eco}): {', '.join(pk)}. Yapay zekâ var olmayan/benzer yazımlı paket "
                    "önerebilir. Onaylamadan önce: paket kayıt defterinde gerçekten var mı, yayıncı ve indirme "
                    "sayısı makul mü, bakım durumu ve lisansı uygun mu? Sonra `make audit` çalıştırın."),
            }})
            return


if __name__ == "__main__":
    main()
