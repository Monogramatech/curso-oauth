#!/usr/bin/env bash
# Aula 4.1, Parte 2: O ataque que o PKCE resolve.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/4.1-parte-2/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
pkce
unalias -a
K="docker exec kc //opt/keycloak/bin/kcadm.sh"; $K config credentials --server http://localhost:8080 --realm master --user admin --password admin
A="http://localhost:8080/realms/curso/protocol/openid-connect"; R=http://localhost:3000/callback; P="&code_challenge=$CH&code_challenge_method=S256"
url() { echo "$A/auth?response_type=code&client_id=$1&redirect_uri=$R&scope=openid&state=abc123$2"; }
troca() { curl -s -o t.json -w "%{http_code} " $A/token -d grant_type=authorization_code -d redirect_uri=$R -d code=$1 "${@:2}"; node -e "const j=JSON.parse(require('fs').readFileSync('t.json','utf8'));console.log(j.error ? j.error+' · '+j.error_description : 'tokens')"; }
api() { curl -s -o u.json -w "%{http_code} " $A/userinfo -H "Authorization: Bearer $T"; grep -o '"preferred_username":"[^"]*"' u.json; echo; }
# Dois clients sem PKCE exigido: um público e um confidencial
echo; echo "== Dois clients sem PKCE exigido: um público e um confidencial"
$K create clients -r curso -s clientId=app-antigo -s publicClient=true -s 'redirectUris=["http://localhost:3000/callback"]'
I=$($K create clients -r curso -s clientId=site-antigo -s publicClient=false -s 'redirectUris=["http://localhost:3000/callback"]' -i)
S=$($K get clients/$I/client-secret -r curso --fields value --format csv --noquotes)
# 1. App antigo: o code copiado basta; a API; o app chega depois; a API de novo
echo; echo "== 1. App antigo: o code copiado basta; a API; o app chega depois; a API de novo"
url app-antigo
pede_code CODE1
troca $CODE1 -d client_id=app-antigo
T=$(node -p "JSON.parse(require('fs').readFileSync('t.json','utf8')).access_token"); api
troca $CODE1 -d client_id=app-antigo
api
# 2. App de fotos (PKCE exigido): sem verifier, e o app depois; com um verifier inventado
echo; echo "== 2. App de fotos (PKCE exigido): sem verifier, e o app depois; com um verifier inventado"
url app-de-fotos $P
pede_code CODE2
troca $CODE2 -d client_id=app-de-fotos
troca $CODE2 -d client_id=app-de-fotos -d code_verifier=$V
url app-de-fotos $P
pede_code CODE3
troca $CODE3 -d client_id=app-de-fotos -d code_verifier=inventado-inventado-inventado-inventado-123
# 3. Site antigo: sem o segredo; depois, o próprio site, com o segredo
echo; echo "== 3. Site antigo: sem o segredo; depois, o próprio site, com o segredo"
url site-antigo
pede_code CODE4
troca $CODE4 -d client_id=site-antigo
url site-antigo
pede_code CODE5
troca $CODE5 -u site-antigo:$S
# 4. O site com o desafio no pedido: o verifier de outra sessão, e o da sessão certa
echo; echo "== 4. O site com o desafio no pedido: o verifier de outra sessão, e o da sessão certa"
url site-antigo $P
pede_code CODE6
troca $CODE6 -u site-antigo:$S -d code_verifier=verifier-de-outra-sessao-de-navegador-1234567
url site-antigo $P
pede_code CODE7
troca $CODE7 -u site-antigo:$S -d code_verifier=$V
# Pedido sem o desafio no app de fotos: volta com erro
echo; echo "== Pedido sem o desafio no app de fotos: volta com erro"
curl -s -o /dev/null -w "%{redirect_url}\n" "$(url app-de-fotos)"
# Desfaz
echo; echo "== Desfaz"
$K delete clients/$I -r curso; $K delete clients/$($K get clients -r curso -q clientId=app-antigo --fields id --format csv --noquotes) -r curso
