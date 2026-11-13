#!/usr/bin/env bash
# Aula 4.1, Parte 3: PKCE por dentro: code_verifier, code_challenge e S256.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.1-parte-3/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"; R=http://localhost:3000/callback; F=app-de-fotos; N=app-antigo
s256() { printf %s "$1" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '='; }
url() { echo "$A/auth?response_type=code&client_id=$1&redirect_uri=$R&scope=openid&state=abc123${2:+&code_challenge=$2}${3:+&code_challenge_method=$3}"; }
troca() { curl -s -o t.json -w "%{http_code} " $A/token -d grant_type=authorization_code -d redirect_uri=$R -d client_id=$1 -d code=$2 "${@:3}"; grep -o '"error[^,}]*' t.json || echo tokens; }
# 1. O verifier (32 bytes) e a conta do S256; 48 bytes dão 64 caracteres
echo; echo "== 1. O verifier (32 bytes) e a conta do S256; 48 bytes dão 64 caracteres"
B=$(openssl rand -base64 32); V=$(echo $B | tr '+/' '-_' | tr -d '='); CH=$(s256 $V); echo "$V ${#V} · $CH ${#CH}"
openssl rand -base64 48 | tr -d '\r\n' | wc -c
# O exemplo da RFC 7636: tem de dar E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
echo; echo "== O exemplo da RFC 7636: tem de dar E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM"
VR=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk; s256 $VR; echo
# 2. App de fotos: par da RFC; 1 caractere trocado; desafio como verifier; 42 caracteres; 43 letras iguais
echo; echo "== 2. App de fotos: par da RFC; 1 caractere trocado; desafio como verifier; 42 caracteres; 43 letras iguais"
url $F $(s256 $VR) S256
pede_code CODE
troca $F $CODE -d code_verifier=$VR
url $F $CH S256
pede_code CODE
troca $F $CODE -d code_verifier=${V%?}.
url $F $CH S256
pede_code CODE
troca $F $CODE -d code_verifier=$CH
V42=${V%?}
url $F $(s256 $V42) S256
pede_code CODE
troca $F $CODE -d code_verifier=$V42
VA=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
url $F $(s256 $VA) S256
pede_code CODE
troca $F $CODE -d code_verifier=$VA
# 3. A conta errada: hash em hexadecimal; hash dos 32 bytes
echo; echo "== 3. A conta errada: hash em hexadecimal; hash dos 32 bytes"
url $F $(printf %s "$V" | openssl dgst -sha256 -r | cut -c1-64) S256
pede_code CODE
troca $F $CODE -d code_verifier=$V
url $F $(echo $B | openssl base64 -d | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=') S256
pede_code CODE
troca $F $CODE -d code_verifier=$V
# 4. App antigo (sem PKCE exigido), plain: o verifier é o desafio do endereço. Depois, só o code
echo; echo "== 4. App antigo (sem PKCE exigido), plain: o verifier é o desafio do endereço. Depois, só o code"
$K create clients -r curso -s clientId=$N -s publicClient=true -s 'redirectUris=["http://localhost:3000/callback"]'
url $N $V plain
pede_code CODE
troca $N $CODE -d code_verifier=$V
url $N $V plain
pede_code CODE
troca $N $CODE
# 5. Desafio do S256 sem o método (vale plain); pedido sem desafio, verifier na troca
echo; echo "== 5. Desafio do S256 sem o método (vale plain); pedido sem desafio, verifier na troca"
url $N $CH
pede_code CODE
troca $N $CODE -d code_verifier=$V
url $N
pede_code CODE
troca $N $CODE -d code_verifier=$V
# 6. App de fotos recusa plain e pedido sem método; os métodos publicados
echo; echo "== 6. App de fotos recusa plain e pedido sem método; os métodos publicados"
curl -s -o /dev/null -w "%{redirect_url}\n" "$(url $F $V plain)"
curl -s -o /dev/null -w "%{redirect_url}\n" "$(url $F $CH)"
curl -s http://localhost:8080/.well-known/oauth-authorization-server/realms/curso | grep -o '"code_challenge_methods[^]]*]'
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$($K get clients -r curso -q clientId=$N --fields id --format csv --noquotes) -r curso
