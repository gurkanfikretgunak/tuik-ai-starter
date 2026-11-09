#!/usr/bin/env python3
"""UserPromptSubmit: prompt'ta hassas veri/sır varsa engeller, şüpheli içerikte uyarır.

Sert eşleşme (geçerli T.C. kimlik no, IBAN, token, özel anahtar) -> prompt ENGELLENİR.
Yumuşak eşleşme (anahtar kelimeler, yapıştırılmış tablo) -> Claude'a uyarı bağlamı eklenir.
"""
import re
from _common import emit, find_sensitive, read_event

SOFT_WORDS = re.compile(
    r"(?i)\b(mikro ?veri|ham ?veri|birim d[üu]zeyi|ki[şs]isel veri|gizli veri|hane ?halk[ıi]|"
    r"anket kay[ıi]t|ihracat kayd[ıi]|vergi no|mersis)\b")


def looks_like_table(text: str) -> bool:
    rows = [l for l in text.splitlines() if len(re.findall(r"[,;\t|]", l)) >= 3]
    return len(rows) >= 15


def main() -> None:
    ev = read_event()
    prompt = ev.get("prompt", "") or ""
    hard = find_sensitive(prompt)
    if hard:
        kinds = sorted({k for k, _ in hard})
        emit({
            "decision": "block",
            "reason": (
                "Mesaj ENGELLENDİ: hassas veri/sır olabilecek içerik bulundu ("
                + ", ".join(kinds)
                + "). Değeri silip sentetik/anonim örnekle yeniden yaz. "
                "Kural: .claude/rules/01-veri-gizliligi.md · Tehdit rehberi: docs/security/ai-kullanim-riskleri.md"),
        })
        return
    warn = []
    if SOFT_WORDS.search(prompt):
        warn.append("Mesajda mikro veri/kişisel veri benzeri ifadeler var; gerçek veri paylaşılıyorsa durdur.")
    if looks_like_table(prompt):
        warn.append("Mesajda yapıştırılmış tablo verisi var; gerçek kayıt olmadığından emin ol (yalnızca sentetik veri).")
    if warn:
        emit({"hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": "[VERİ GİZLİLİĞİ UYARISI] " + " ".join(warn)
            + " Gerçek/hassas veri varsa işlemi sürdürme, kullanıcıyı uyar ve sentetik örnek iste.",
        }})


if __name__ == "__main__":
    main()
