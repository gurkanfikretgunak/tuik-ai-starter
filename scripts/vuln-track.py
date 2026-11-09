#!/usr/bin/env python3
"""Zafiyet takibi: bağımlılık taraması ve docs/security/zafiyet-kayitlari.md yönetimi.

Kullanım:
  python3 scripts/vuln-track.py summary          # kısa özet (SessionStart hook'u kullanır)
  python3 scripts/vuln-track.py list             # açık kayıtlar
  python3 scripts/vuln-track.py scan [--write]   # npm audit / pip-audit / govulncheck çalıştırır
  python3 scripts/vuln-track.py add --kaynak X --bilesen Y --ozet "..." --onem Yüksek --sorumlu ekip
  python3 scripts/vuln-track.py hooks            # hook bulgu günlüğünü özetler
Tarama araçları kuruluysa çalışır; yoksa atlanır ve bildirilir (hata vermez).
"""
import argparse
import datetime as dt
import json
import os
import re
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REG = os.path.join(ROOT, "docs", "security", "zafiyet-kayitlari.md")
LOG = os.path.join(ROOT, ".claude", "logs", "hook-bulgular.jsonl")
ORDER = ["Kritik", "Yüksek", "Orta", "Düşük"]
SEV_MAP = {"critical": "Kritik", "high": "Yüksek", "moderate": "Orta", "medium": "Orta", "low": "Düşük"}
OPEN = {"Açık", "İnceleniyor"}


def read_rows():
    rows = []
    if not os.path.isfile(REG):
        return rows
    for line in open(REG, encoding="utf-8"):
        if line.startswith("| ") and not line.startswith("| ID") and not line.startswith("|---"):
            c = [x.strip() for x in line.strip().strip("|").split("|")]
            if len(c) >= 10:
                rows.append(c)
    return rows


def real_rows():
    return [r for r in read_rows() if not r[0].startswith("ORNEK-")]


def next_id():
    year = dt.date.today().year
    nums = [int(m.group(1)) for r in real_rows() if (m := re.match(rf"ZAF-{year}-(\d+)", r[0]))]
    return f"ZAF-{year}-{(max(nums) + 1 if nums else 1):03d}"


def append(kaynak, bilesen, ozet, onem, sorumlu="atanmadı", not_=""):
    due = {"Kritik": 7, "Yüksek": 30, "Orta": 90}.get(onem)
    hedef = (dt.date.today() + dt.timedelta(days=due)).isoformat() if due else "-"
    row = f"| {next_id()} | {dt.date.today().isoformat()} | {kaynak} | {bilesen} | {ozet} | {onem} | Açık | {sorumlu} | {hedef} | {not_} |\n"
    with open(REG, "a", encoding="utf-8") as f:
        f.write(row)
    return row.strip()


def summary():
    rows = [r for r in real_rows() if r[6] in OPEN]
    if not rows:
        return "açık kayıt yok."
    cnt = {s: sum(1 for r in rows if r[5] == s) for s in ORDER}
    today = dt.date.today().isoformat()
    late = [r[0] for r in rows if re.match(r"\d{4}-", r[8]) and r[8] < today]
    s = f"{len(rows)} açık — " + ", ".join(f"{k}: {v}" for k, v in cnt.items() if v)
    return s + (f" · SÜRESİ GEÇEN: {', '.join(late)}" if late else "")


def run(cmd, cwd):
    try:
        return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=180)
    except Exception as e:
        return None


def scan(write):
    found = []
    web = os.path.join(ROOT, "apps", "web")
    if os.path.isfile(os.path.join(web, "package-lock.json")) and shutil.which("npm"):
        r = run(["npm", "audit", "--json", "--omit=dev"], web)
        try:
            data = json.loads(r.stdout) if r else {}
            for name, v in (data.get("vulnerabilities") or {}).items():
                via = [x for x in v.get("via", []) if isinstance(x, dict)]
                title = via[0].get("title", "bağımlılık zafiyeti") if via else "dolaylı bağımlılık zafiyeti"
                found.append(("npm audit", f"{name}@{v.get('range', '?')}", title, SEV_MAP.get(v.get("severity"), "Orta")))
        except json.JSONDecodeError:
            print("npm audit çıktısı okunamadı (ağ erişimi gerekir).")
    else:
        print("atlandı: npm audit (package-lock.json veya npm yok)")
    comp = os.path.join(ROOT, "compute")
    if shutil.which("pip-audit"):
        r = run(["pip-audit", "-f", "json", "--progress-spinner=off"], comp)
        try:
            for d in (json.loads(r.stdout).get("dependencies", []) if r else []):
                for v in d.get("vulns", []):
                    found.append(("pip-audit", f"{d['name']}=={d['version']}", f"{v['id']}: {v.get('description', '')[:80]}", "Yüksek"))
        except (json.JSONDecodeError, KeyError):
            print("pip-audit çıktısı okunamadı.")
    else:
        print("atlandı: pip-audit (kurulu değil: pip install pip-audit)")
    api = os.path.join(ROOT, "services", "api")
    if shutil.which("govulncheck"):
        r = run(["govulncheck", "./..."], api)
        if r and r.returncode != 0 and "Vulnerability" in (r.stdout or ""):
            found.append(("govulncheck", "services/api", "Go zafiyeti bulundu; çıktıyı inceleyin", "Yüksek"))
    else:
        print("atlandı: govulncheck (kurulu değil: go install golang.org/x/vuln/cmd/govulncheck@latest)")

    existing = {(r[2], r[3]) for r in real_rows()}
    new = [f for f in found if (f[0], f[1]) not in existing]
    print(f"\nbulunan: {len(found)} · yeni: {len(new)}")
    for f in new:
        print(f"  [{f[3]}] {f[0]} · {f[1]} · {f[2]}")
        if write:
            append(f[0], f[1], f[2], f[3])
    if new and not write:
        print("\nKayıt defterine eklemek için: python3 scripts/vuln-track.py scan --write")


def hooks_log():
    if not os.path.isfile(LOG):
        print("hook bulgusu yok.")
        return
    cnt = {}
    for line in open(LOG, encoding="utf-8"):
        try:
            e = json.loads(line)
            k = f"{e.get('tur')}: {e.get('kural') or ','.join(e.get('bulgu', [])) or os.path.basename(e.get('dosya',''))}"
            cnt[k] = cnt.get(k, 0) + 1
        except json.JSONDecodeError:
            pass
    for k, v in sorted(cnt.items(), key=lambda x: -x[1]):
        print(f"{v:4d}  {k}")


def main():
    p = argparse.ArgumentParser()
    sp = p.add_subparsers(dest="cmd", required=True)
    sp.add_parser("summary"); sp.add_parser("list"); sp.add_parser("hooks")
    s = sp.add_parser("scan"); s.add_argument("--write", action="store_true")
    a = sp.add_parser("add")
    for k in ("kaynak", "bilesen", "ozet"):
        a.add_argument(f"--{k}", required=True)
    a.add_argument("--onem", choices=ORDER, default="Orta")
    a.add_argument("--sorumlu", default="atanmadı")
    a.add_argument("--not", dest="not_", default="")
    args = p.parse_args()
    if args.cmd == "summary":
        print(summary())
    elif args.cmd == "list":
        for r in real_rows():
            if r[6] in OPEN:
                print(f"{r[0]}  [{r[5]}]  {r[3]}  {r[4]}  (hedef {r[8]}, {r[7]})")
        print(summary())
    elif args.cmd == "scan":
        scan(args.write)
    elif args.cmd == "add":
        print(append(args.kaynak, args.bilesen, args.ozet, args.onem, args.sorumlu, args.not_))
    elif args.cmd == "hooks":
        hooks_log()


if __name__ == "__main__":
    main()
