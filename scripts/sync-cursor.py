#!/usr/bin/env python3
"""`.claude/` içeriğinden Cursor uyumlu `.cursor/` çıktısı üretir (tek kaynak: .claude).

  python3 scripts/sync-cursor.py
rules -> .cursor/rules/*.mdc (paths -> globs; paths yoksa alwaysApply: true)
commands -> .cursor/commands/*.md · skills -> .cursor/skills/<ad>/SKILL.md
"""
import os
import re
import shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC, DST = os.path.join(ROOT, ".claude"), os.path.join(ROOT, ".cursor")


def split_fm(text):
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    return (m.group(1), m.group(2)) if m else ("", text)


def main():
    for sub in ("rules", "commands", "skills"):
        shutil.rmtree(os.path.join(DST, sub), ignore_errors=True)
    os.makedirs(os.path.join(DST, "rules"), exist_ok=True)
    os.makedirs(os.path.join(DST, "commands"), exist_ok=True)
    n = 0
    for f in sorted(os.listdir(os.path.join(SRC, "rules"))):
        if not f.endswith(".md"):
            continue
        fm, body = split_fm(open(os.path.join(SRC, "rules", f), encoding="utf-8").read())
        paths = re.findall(r'-\s*"([^"]+)"', fm)
        desc = re.sub(r"^[#\s]+", "", body.strip().splitlines()[0]) if body.strip() else f
        head = f"---\ndescription: {desc}\n"
        head += ("globs: " + ",".join(paths) + "\nalwaysApply: false\n") if paths else "alwaysApply: true\n"
        open(os.path.join(DST, "rules", f[:-3] + ".mdc"), "w", encoding="utf-8").write(head + "---\n" + body)
        n += 1
    for f in sorted(os.listdir(os.path.join(SRC, "commands"))):
        _, body = split_fm(open(os.path.join(SRC, "commands", f), encoding="utf-8").read())
        open(os.path.join(DST, "commands", f), "w", encoding="utf-8").write(body.lstrip())
    shutil.copytree(os.path.join(SRC, "skills"), os.path.join(DST, "skills"), dirs_exist_ok=True)
    print(f"{n} rule, komutlar ve skill'ler .cursor/ altına eşitlendi (düzenleme .claude/ içinde yapılır).")


if __name__ == "__main__":
    main()
