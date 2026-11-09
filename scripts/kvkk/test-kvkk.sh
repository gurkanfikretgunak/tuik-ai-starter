#!/usr/bin/env bash
# KVKK kontrolcülerinin davranış testleri. Çalıştır: make test-kvkk
# Fixture'lar çalışma anında geçici dizinde ve parçalı üretilir; böylece bu dosya
# depo taramasında bulgu üretmez ve hiçbir gerçek veri kullanılmaz.
cd "$(dirname "$0")/../.." || exit 1
DIR="$PWD/scripts/kvkk"
TMP="$(mktemp -d -t kvkktest.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
fail=0

ok()   { echo "OK    $1"; }
bad()  { echo "HATA  $1"; fail=1; }

# run <kontrolcü> <kök> [ENV=DEĞER...] -> stdout'a çıktı, $RC'ye çıkış kodu
run() {
  local c="$1" root="$2"; shift 2
  OUT=$(env KVKK_ROOT="$root" "$@" bash "$DIR/$c.sh" 2>&1); RC=$?
}
expect_hit() {  # ad kontrolcü kök beklenen_alt_dize [env...]
  local name="$1" c="$2" root="$3" want="$4"; shift 4
  run "$c" "$root" "$@"
  if printf '%s' "$OUT" | grep -q -- "$want"; then ok "$name"; else bad "$name (beklenen: $want) -> $OUT"; fi
}
expect_clean() {  # ad kontrolcü kök [env...]
  local name="$1" c="$2" root="$3"; shift 3
  run "$c" "$root" "$@"
  if [ -z "$OUT" ] && [ $RC -eq 0 ]; then ok "$name"; else bad "$name (boş beklenirdi) -> $OUT"; fi
}
fresh() { rm -rf "$TMP/t"; mkdir -p "$TMP/t"; cd "$TMP/t" || exit 1; }

V_TCKN="1234567""8950"          # sağlaması geçerli sentetik
I_TCKN="1234567""8901"          # sağlaması tutmaz
OK_IBAN="TR33""0006100519786457841326"   # yayımlanmış örnek IBAN (mod-97 geçerli)
BAD_IBAN="TR33""0006100519786457841327"
AWS="AKIA""ABCDEFGHIJKLMNOP"
PK="-----BEGIN RSA ""PRIVATE KEY-----"

# --- TCKN -----------------------------------------------------------------
fresh; printf 'musteri: %s\n' "$V_TCKN" > a.txt
expect_hit  "tckn: geçerli sağlama bulgu verir" check-tckn "$TMP/t" 'HATA \[TCKN\]'
fresh; printf 'sayi %s var\n' "$I_TCKN" > a.txt
expect_clean "tckn: sağlaması tutmayan 11 hane sessiz" check-tckn "$TMP/t"
fresh; printf 'tckn: %s\n' "$I_TCKN" > a.txt
expect_hit  "tckn: anahtar sözcük yanında şüpheli sayı UYARI" check-tckn "$TMP/t" 'UYARI \[TCKN-BAĞLAM\]'
fresh; printf 'x %s y\n' "1000000""0146" > a.txt
expect_clean "tckn: allowlist'teki bilinen sentetik değer geçer" check-tckn "$TMP/t"
fresh; printf 'a%sb\n' "$V_TCKN" > a.txt
expect_clean "tckn: harfe bitişik sayı (hash benzeri) sessiz" check-tckn "$TMP/t"
fresh; printf 'vergi no: %s\n' "123456""7890" > a.txt
expect_hit  "vkn: bağlamlı 10 hane UYARI" check-tckn "$TMP/t" 'UYARI \[VKN-BAĞLAM\]'
fresh; printf 'no %s\n' "$V_TCKN" > a.txt
run check-tckn "$TMP/t"
if printf '%s' "$OUT" | grep -q "$V_TCKN"; then bad "tckn: değer maskelenmeli, açık yazılmış"; else ok "tckn: çıktı maskeli"; fi

# --- IBAN -----------------------------------------------------------------
fresh; printf 'hesap %s\n' "$OK_IBAN" > a.txt
expect_hit  "iban: geçerli TR IBAN bulgu verir" check-iban "$TMP/t" 'HATA \[IBAN\]'
fresh; printf 'hesap %s\n' "TR33 ""0006 1005 1978 6457 8413 26" > a.txt
expect_hit  "iban: boşluklu biçim de yakalanır" check-iban "$TMP/t" 'HATA \[IBAN\]'
fresh; printf 'hesap %s\n' "$BAD_IBAN" > a.txt
expect_clean "iban: sağlaması tutmayan sessiz" check-iban "$TMP/t"

# --- İletişim -------------------------------------------------------------
fresh; printf 'iletisim: %s\n' "ayse.demir""@kurum.gov.tr" > a.txt
expect_hit  "iletişim: gerçek alan adlı e-posta UYARI" check-contact "$TMP/t" 'UYARI \[E-POSTA\]'
fresh; printf 'iletisim: kisi@example.com ve a@b.test ve noreply@anthropic.com\n' > a.txt
expect_clean "iletişim: example/test/noreply yer tutucu sessiz" check-contact "$TMP/t"
fresh; printf 'tel: %s\n' "0532 123 ""45 67" > a.txt
expect_hit  "iletişim: cep telefonu HATA" check-contact "$TMP/t" 'HATA \[TELEFON\]'
fresh; printf 'tel: %s\n' "+90 532 123 ""45 67" > a.txt
expect_hit  "iletişim: +90 biçimi HATA" check-contact "$TMP/t" 'HATA \[TELEFON\]'
fresh; printf 'seri 2024-01-15 100.0 1234567\n' > a.txt
expect_clean "iletişim: tarih/sayı yanlış pozitif vermez" check-contact "$TMP/t"

# --- Sırlar ---------------------------------------------------------------
fresh; printf 'k=%s\n' "$AWS" > a.txt
expect_hit  "sır: bulut anahtarı" check-secrets "$TMP/t" 'HATA \[SIR\]'
fresh; printf '%s\n' "$PK" > a.txt
expect_hit  "sır: özel anahtar başlığı" check-secrets "$TMP/t" 'HATA \[SIR\]'
fresh; printf '%s = "%s"\n' "api_""key" "abcd1234""efgh5678" > a.txt
expect_hit  "sır: anahtar=değer ataması" check-secrets "$TMP/t" 'HATA \[SIR\]'
fresh; printf 'dsn: %s\n' "postgres:""//kullanici:gizlisifre""@db.local/x" > a.txt
expect_hit  "sır: URL içinde kimlik bilgisi" check-secrets "$TMP/t" 'HATA \[SIR\]'
fresh; printf 'token = "<YER_TUTUCU>"\npassword = "YER_TUTUCU_degeri"\n' > a.txt
expect_clean "sır: yer tutucu değerler sessiz" check-secrets "$TMP/t"
fresh; printf 'k=%s\n' "$AWS" > a.txt
run check-secrets "$TMP/t"
if printf '%s' "$OUT" | grep -q "$AWS"; then bad "sır: değer açık yazılmış"; else ok "sır: çıktı değeri açık yazmaz"; fi

# --- Dosyalar -------------------------------------------------------------
fresh; mkdir -p .claude/hooks
printf '#!/usr/bin/env bash\ngrep -q hassas-dosya && exit 2\nexit 0\n' > .claude/hooks/block-sensitive-files.sh
printf 'x' > hassas-dosya.txt
expect_hit  "dosya: proje hook'u hassas dediği yol HATA (tek kaynak)" check-files "$TMP/t" 'HATA \[DOSYA\]'
fresh; printf 'x' > sunucu.key
expect_hit  "dosya: anahtar dosyası HATA" check-files "$TMP/t" 'HATA \[ANAHTAR-DOSYASI\]'
fresh; printf 'x' > veri.parquet
expect_hit  "dosya: parquet HATA" check-files "$TMP/t" 'HATA \[VERI-DOSYASI\]'
fresh; mkdir -p data; printf 'a,b\n1,2\n' > data/gercek.csv
expect_hit  "dosya: data/ altında sample dışı HATA" check-files "$TMP/t" 'HATA \[VERI-KLASORU\]'
fresh; mkdir -p data/sample; printf 'donem,bolge,deger\n2024-01,A,1\n' > data/sample/ok.csv
expect_clean "dosya: data/sample sentetik csv sessiz" check-files "$TMP/t"
fresh; mkdir -p data/sample; head -c 2048 /dev/zero | tr '\0' 'a' > data/sample/buyuk.json
expect_hit  "dosya: büyük örnek UYARI" check-files "$TMP/t" 'UYARI \[ORNEK-BUYUK\]' KVKK_MAX_SAMPLE_KB=1
fresh; printf '{"cells":[{"outputs":[{"output_type":"stream"}]}]}' > n.ipynb
expect_hit  "dosya: çıktılı not defteri UYARI" check-files "$TMP/t" 'UYARI \[NOTEBOOK\]'

# --- Mikro veri -----------------------------------------------------------
fresh; mkdir -p data/sample; printf 'tckn,ad,soyad,deger\n1,x,y,3\n' > data/sample/a.csv
expect_hit  "mikro: kişisel sütun adları HATA" check-microdata "$TMP/t" 'HATA \[KISISEL-SUTUN\]'
fresh; mkdir -p data/sample; printf 'Doğum Tarihi;Adres;değer\n' > data/sample/a.csv
expect_hit  "mikro: Türkçe/boşluklu sütun adı da yakalanır" check-microdata "$TMP/t" 'HATA \[KISISEL-SUTUN\]'
fresh; mkdir -p data/sample; printf 'donem,bolge,deger\n2024-01,A,1\n' > data/sample/a.csv
expect_clean "mikro: dönem/bölge/değer sessiz" check-microdata "$TMP/t"
fresh; mkdir -p data/sample; printf 'birey_id,deger\n1,2\n' > data/sample/a.csv
expect_hit  "mikro: birim düzeyi kimlik UYARI" check-microdata "$TMP/t" 'UYARI \[BIRIM-DUZEYI\]'
fresh; mkdir -p data/sample; printf 'donem,deger\n1,1\n2,2\n3,3\n4,4\n5,5\n' > data/sample/a.csv
expect_hit  "mikro: satır sayısı eşiği UYARI" check-microdata "$TMP/t" 'UYARI \[ORNEK-BUYUK\]' KVKK_MAX_SAMPLE_ROWS=3
fresh; mkdir -p data/sample; printf '{"gozlemler":[{"soyad":"x","deger":1}]}' > data/sample/a.json
expect_hit  "mikro: json anahtarı HATA" check-microdata "$TMP/t" 'HATA \[KISISEL-SUTUN\]'

# --- Çalıştırıcı, hazırlanan dosya modu ve geçmiş -------------------------
fresh; git init -q . 2>/dev/null
git config user.email "t@example.com"; git config user.name "t"
printf 'temiz\n' > temiz.txt; git add temiz.txt; git commit -q -m t
printf 'k=%s\n' "$AWS" > sizinti.txt
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" --staged 2>&1); rc=$?
if [ $rc -eq 0 ]; then ok "run-all --staged: hazırlanmamış dosya taranmaz"; else bad "run-all --staged temiz olmalıydı -> $out"; fi
git add sizinti.txt
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" --staged 2>&1); rc=$?
if [ $rc -eq 1 ] && printf '%s' "$out" | grep -q 'HATA \[SIR\]'; then ok "run-all --staged: hazırlanan sır commit'i engeller (çıkış 1)"; else bad "run-all --staged sır yakalamalıydı -> $out"; fi
git commit -q -m s 2>/dev/null; git rm -q -f sizinti.txt; git commit -q -m sil
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" 2>&1); rc=$?
if [ $rc -eq 0 ]; then ok "run-all: silinmiş sır güncel ağaçta bulgu vermez"; else bad "run-all temiz olmalıydı -> $out"; fi
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" --history 2>&1); rc=$?
if [ $rc -eq 1 ] && printf '%s' "$out" | grep -q 'GECMIS-SIR'; then ok "run-all --history: geçmişte kalan sır yakalanır"; else bad "--history sır yakalamalıydı -> $out"; fi
if printf '%s' "$out" | grep -q "$AWS"; then bad "geçmiş taraması değeri açık yazmış"; else ok "geçmiş taraması değeri yazmaz"; fi
fresh; printf 'tel %s\nmail %s\n' "0532 123 ""45 67" "a.b""@kurum.gov.tr" > a.txt
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" 2>&1); rc=$?
[ $rc -eq 1 ] && ok "run-all: HATA varsa çıkış 1" || bad "run-all çıkış 1 olmalıydı"
fresh; printf 'mail %s\n' "a.b""@kurum.gov.tr" > a.txt
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" 2>&1); rc=$?
[ $rc -eq 0 ] && ok "run-all: yalnız UYARI çıkış 0" || bad "yalnız UYARI çıkış 0 olmalıydı -> $out"
out=$(bash "$DIR/run-all.sh" --root "$TMP/t" --strict 2>&1); rc=$?
[ $rc -eq 1 ] && ok "run-all --strict: UYARI da başarısız" || bad "--strict çıkış 1 olmalıydı"

[ $fail -eq 0 ] && echo "TÜM KVKK TESTLERİ GEÇTİ" || { echo "BAŞARISIZ TEST VAR"; exit 1; }
