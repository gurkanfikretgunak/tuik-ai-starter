#!/usr/bin/env bash
# Mikro veri izi: örnek/şablon/örnekler altındaki CSV-TSV başlıkları ve JSON anahtarları
# kişisel veri sütunu adı (ad, soyad, tckn, adres, telefon...) içeriyor mu; satır sayısı
# örnek için makul mü? Sütun adı sözlüğü yalnızca ad eşleştirir, değer okumaz/yazmaz.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
MAX_ROWS="${KVKK_MAX_SAMPLE_ROWS:-500}"

# Normalize: küçük harf, Türkçe karakterleri ASCII'ye, ayraçları sil.
norm() {
  printf '%s' "$1" | sed 's/İ/i/g; s/I/i/g; s/ı/i/g; s/ş/s/g; s/Ş/s/g; s/ğ/g/g; s/Ğ/g/g; s/ü/u/g; s/Ü/u/g; s/ö/o/g; s/Ö/o/g; s/ç/c/g; s/Ç/c/g' |
    tr 'A-Z' 'a-z' | tr -d '_ "-'
}
PII='^(ad|adi|soyad|soyadi|adsoyad|isim|tckn|tcno|tc|tckimlik|tckimlikno|kimlik|kimlikno|adres|adresi|telefon|tel|gsm|cep|eposta|email|mail|dogum|dogumtarihi|dogumyeri|anneadi|babaadi|vkn|vergino|iban|plaka|ipadresi|ip|enlem|boylam|latitude|longitude)$'
UNIT='^(bireyid|kisiid|haneid|firmaid|isyeriid|kayitno|birimid|musteriid|hastaid|ogrenciid)$'

scan() {
  [ -s "$KVKK_FILES" ] && tr '\0' '\n' < "$KVKK_FILES" | while IFS= read -r f; do
    case "$f" in
      data/sample/*|examples/*|templates/*) ;;
      *) continue;;
    esac
    lower=$(printf '%s' "$f" | tr 'A-Z' 'a-z')
    case "$lower" in
      *.csv|*.tsv)
        header=$(head -n 1 "$f" | tr -d '\r')
        printf '%s' "$header" | tr ',;\t' '\n\n\n' | while IFS= read -r col; do
          n=$(norm "$col")
          [ -z "$n" ] && continue
          printf '%s' "$n" | grep -qE "$PII"  && echo "HATA [KISISEL-SUTUN] $f:1: kişisel veri sütun adı \"$col\""
          printf '%s' "$n" | grep -qE "$UNIT" && echo "UYARI [BIRIM-DUZEYI] $f:1: birim düzeyi kimlik sütunu \"$col\" (mikro veri izi)"
        done
        rows=$(( $(wc -l < "$f") - 1 ))
        [ "$rows" -gt "$MAX_ROWS" ] && echo "UYARI [ORNEK-BUYUK] $f: $rows satır (> $MAX_ROWS); gerçek veri olabilir";;
      *.json)
        grep -oE '"[^"]+"[[:space:]]*:' "$f" 2>/dev/null | sed -E 's/"([^"]+)".*/\1/' | sort -u | while IFS= read -r key; do
          n=$(norm "$key")
          printf '%s' "$n" | grep -qE "$PII"  && echo "HATA [KISISEL-SUTUN] $f: kişisel veri anahtarı \"$key\""
          printf '%s' "$n" | grep -qE "$UNIT" && echo "UYARI [BIRIM-DUZEYI] $f: birim düzeyi kimlik anahtarı \"$key\""
        done;;
    esac
  done | sort -u
}
out=$(scan)
kvkk_finish "$out"
