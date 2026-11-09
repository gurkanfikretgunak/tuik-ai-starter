#!/usr/bin/env bash
# Dosya adı / uzantı / konum denetimi: depoya girmemesi gereken dosya türleri.
# Hassas yol kuralının tek kaynağı .claude/hooks/block-sensitive-files.sh'tir; burada
# yinelenmez, doğrudan o hook çağrılır. Ek olarak veri, anahtar ve veritabanı türleri taranır.
. "$(dirname "$0")/lib.sh"; kvkk_prepare
HOOK="$KVKK_ROOT/.claude/hooks/block-sensitive-files.sh"
MAX_KB="${KVKK_MAX_SAMPLE_KB:-512}"

scan() {
  [ -s "$KVKK_FILES" ] && tr '\0' '\n' < "$KVKK_FILES" | while IFS= read -r f; do
    base="${f##*/}"; lower=$(printf '%s' "$f" | tr 'A-Z' 'a-z')
    case "$base" in *.example|*.sample|*.template) example=1;; *) example=0;; esac

    # 1) Proje hook'unun hassas saydığı yollar (tek kaynak).
    if [ "$example" = 0 ] && [ -f "$HOOK" ]; then
      printf '{"tool_input":{"file_path":"%s"}}' "$f" | bash "$HOOK" >/dev/null 2>&1
      [ $? -eq 2 ] && echo "HATA [DOSYA] $f: hassas yol/dosya kuralına uyuyor (hook kuralı)"
    fi

    # 2) Anahtar, sertifika, parola kasası dosyaları.
    case "$lower" in
      *.key|*.p12|*.pfx|*.jks|*.keystore|*.kdbx|*.ovpn|*.crt|*.cer)
        [ "$example" = 0 ] && echo "HATA [ANAHTAR-DOSYASI] $f: anahtar/sertifika/kasa dosyası depoya girmez";;
    esac

    # 3) Mikro veri / istatistik paketi / veritabanı / yedek dosyaları.
    case "$lower" in
      *.sas7bdat|*.rds|*.rdata|*.parquet|*.feather|*.sqlite|*.sqlite3|*.db|*.mdb|*.accdb|*.bak|*.dump)
        echo "HATA [VERI-DOSYASI] $f: veri/veritabanı dosyası türü depoya girmez";;
      *.xlsx|*.xls|*.ods)
        case "$lower" in data/sample/*|examples/*|templates/*) ;; *)
          echo "UYARI [VERI-DOSYASI] $f: tablo dosyası; yalnızca sentetik veri olduğundan emin ol";; esac;;
      *.sql)
        grep -qiE 'insert[[:space:]]+into' "$f" 2>/dev/null &&
          echo "UYARI [VERI-DOSYASI] $f: INSERT içeren SQL; gerçek kayıt olmadığını doğrula";;
    esac

    # 4) Veri klasörü: yalnızca data/sample/ serbest.
    case "$f" in
      data/sample/*|data/README.md) ;;
      data/*) echo "HATA [VERI-KLASORU] $f: data/ altında yalnızca data/sample/ izinli";;
    esac

    # 5) CSV/TSV/JSON veri: data/sample dışında UYARI, örnek veri büyükse UYARI.
    case "$lower" in
      *.csv|*.tsv)
        case "$f" in data/sample/*|examples/*|templates/*|*/testdata/*|*/fixtures/*) ;;
          *) echo "UYARI [VERI-DOSYASI] $f: veri dosyası data/sample dışında; sentetik olmalı";; esac;;
    esac
    case "$f" in data/sample/*)
      kb=$(( $(wc -c < "$f") / 1024 ))
      [ "$kb" -gt "$MAX_KB" ] && echo "UYARI [ORNEK-BUYUK] $f: ${kb} KB (> ${MAX_KB} KB); örnek veri küçük ve sentetik kalmalı";; esac

    # 6) Çıktısı temizlenmemiş not defteri.
    case "$lower" in *.ipynb)
      grep -qE '"output_type"' "$f" 2>/dev/null &&
        echo "UYARI [NOTEBOOK] $f: çıktı hücreleri dolu; veri sızdırabilir (çıktıları temizle)";; esac
  done | sort -u
}
out=$(scan)
kvkk_finish "$out"
